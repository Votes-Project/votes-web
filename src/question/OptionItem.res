module LongPress = {
  type t = {
    holdTime: float,
    progress: float,
    hasReachedThreshold: bool,
    startCounter: unit => promise<unit>,
    stopCounter: unit => unit,
  }

  let use = (~holdDelay, ~onSubmit) => {
    let (holdTime, setHoldTime) = React.useState(_ => 0.0)
    let (progress, setProgress) = React.useState(_ => 0.0)
    let (hasReachedThreshold, setHasReachedThreshold) = React.useState(_ => false)
    let holdIntervalRef = React.useRef(None)

    let normalize = (value, min, max) => {
      (value -. min) /. (max -. min) *. 100.
    }

    let clearTime = () => {
      setHoldTime(_ => 0.0)
      setProgress(_ => 0.0)
      setHasReachedThreshold(_ => false)
    }

    let stopCounter = () => {
      switch holdIntervalRef.current {
      | Some(intervalId) =>
        clearTime()
        clearInterval(intervalId)
        holdIntervalRef.current = None
        ()
      | None => ()
      }
    }
    let startCounter = async () => {
      await Promise.make((_, _) => holdIntervalRef.current = setInterval(() => {
            // Check if enough time has elapsed
            setHoldTime(
              time =>
                switch time {
                | time if time > holdDelay =>
                  setHasReachedThreshold(_ => true)
                  onSubmit()->ignore
                  stopCounter()
                  0.0

                | _ =>
                  setProgress(_ => normalize(time, 0., holdDelay))
                  time +. 10.
                },
            )
          }, 10)->Some)
    }
    {holdTime, progress, hasReachedThreshold, startCounter, stopCounter}
  }
}

module CircleProgress = {
  open FramerMotion
  @react.component
  let make = (~progress, ~size=100) => {
    let radius = 45
    let circumference = Math.ceil(2. *. Math.Constants.pi *. radius->Int.toFloat)->Float.toInt
    let fillPercents = Math.abs(Math.ceil(progress *. float(circumference) /. 100.))->Float.toInt

    <div className="h-full flex justify-center items-center">
      <svg
        viewBox="0 0 100 100"
        version="1.1"
        xmlns="http://www.w3.org/2000/svg"
        width={size->Int.toString}
        height={size->Int.toString}>
        <circle
          cx="50"
          cy="50"
          className="circle fill-transparent stroke-[1rem] stroke-default-darker lg:stroke-active"
          r={radius->Int.toString}
        />
      </svg>
      <svg
        viewBox="0 0 100 100"
        width={size->Int.toString}
        height={size->Int.toString}
        className="absolute rotate-90 overflow-visible">
        <FramerMotion.Circle
          cx="50"
          cy="50"
          r={radius->Int.toString}
          className="circle fill-transparent stroke-[1rem] stroke-default-dark lg:stroke-primary"
          strokeDashoffset={fillPercents->Int.toString}
          strokeDasharray={circumference->Int.toString}
        />
      </svg>
    </div>
  }
}

@react.component
let make = (~option, ~index) => {
  let {queryParams, setParams} = Routes.Main.Question.Route.useQueryParams()
  let keys = UseKeyPairHook.useKeyPair()

  let signAnswer = async (~answer, ~day, jwk, privateKey) => {
    open Dict
    open Jose

    let answerJson = JSON.Encode.int(answer)
    let dayJson = JSON.Encode.float(day)

    let answerDict = Dict.make()
    answerDict->set("answer", answerJson)
    answerDict->set("day", dayJson)

    let answerJson = JSON.Encode.object(answerDict)
    await JWT.Sign.make(answerJson)
    ->JWT.Sign.setProtectedHeader({alg: ES256, jwk})
    ->JWT.Sign.sign(privateKey)
  }

  let handleVote = async optionIndex => {
    switch keys {
    | Some({privateKey, jwk}) =>
      let privateKey = await Jose.importPKCS8(privateKey, ~alg=ES256, ~options={extractable: true})

      let jwt = await signAnswer(~answer=optionIndex, ~day=Date.now(), jwk, privateKey)

      Dom.Storage2.localStorage->Dom.Storage2.setItem("votesdev_answer_jwt", jwt)

      Dom.Storage2.localStorage->Dom.Storage2.setItem(
        "votesdev_answer_timestamp",
        Date.now()->Float.toString,
      )

      setParams(~navigationMode_=Push, ~removeNotControlledParams=false, ~setter=c => {
        ...c,
        answer: None,
      })
    | _ => window->Window.alert("Error generating client keys")
    }
  }

  let holdDelay = 1000.
  let {progress, startCounter, stopCounter} = LongPress.use(~holdDelay, ~onSubmit=() =>
    handleVote(index)
  )

  let ref = React.useRef(Nullable.null)

  let handleSelect = _ => {
    setParams(~navigationMode_=Push, ~removeNotControlledParams=false, ~setter=c => {
      ...c,
      answer: Some(index),
    })
  }
  <li
    className={`focus:outline-none focus:ring-0 relative font-semibold text-sm my-3 w-full flex items-center text-left backdrop-blur-md transition-all duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg bg-default lg:bg-secondary hover:lg:scale-105 focus:lg:scale-105`}
    key={index->Int.toString}
    ref={ReactDOM.Ref.domRef(ref)}
    onPointerLeave={_ => {
      stopCounter()->ignore
    }}
    onPointerDown={e => {
      handleSelect(e)
      startCounter()->ignore
    }}
    onPointerUp={_ => {
      stopCounter()->ignore
    }}>
    <div
      className=" pointer-events-none w-9 flex flex-1 items-center justify-center  font-bold text-3xl h-full text-default-dark lg:text-primary-dark px-5 rounded-l-lg ">
      {switch queryParams.answer {
      | Some(answer) if answer == index => <CircleProgress progress size=25 />
      | _ => (index + 65)->String.fromCharCode->React.string
      }}
    </div>
    <button
      className={`select-none focus:outline-none focus:ring-0 w-full  flex flex-row items-center lg:my-2 first:mb-2 py-2   px-2 min-h-[80px] overflow-hidden  transition-all`}
      key={index->Int.toString}>
      {option->React.string}
    </button>
  </li>
}
