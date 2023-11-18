ReactModal.setAppElement("#root")

module QuestionTitle = {
  module Fragment = %relay(`
    fragment SingleQuestion_QuestionTitle_question on Question {
      question
    }
  `)

  let titleStyle = titleLength => {
    if titleLength <= 50 {
      "text-4xl"
    } else if titleLength <= 150 {
      "text-2xl"
    } else {
      "text-xl"
    }
  }

  @react.component
  let make = (~question) => {
    let question = Fragment.useOpt(question)
    let title = question->Option.map(q => q.question)->Option.getWithDefault("")
    open FramerMotion

    <div className="">
      <Motion.Div
        layout=True
        layoutId="daily-question-title"
        className={`font-bold [text-wrap:balance] text-center text-default-darker px-4  ${titleStyle(
            title->String.length,
          )}`}>
        {("\"" ++ title ++ "\"")->React.string}
      </Motion.Div>
    </div>
  }
}

module LinkStatusTooltip = {
  @react.component
  let make = (~verificationData) => {
    open Verification

    switch verificationData {
    | BrightIdError(_) =>
      <ReactTooltip anchorSelect="#brightid-link-status">
        <div className="flex flex-col justify-center items-center">
          <p className="text-white text-sm font-semibold">
            {"Link Votes to Bright ID"->React.string}
          </p>
        </div>
      </ReactTooltip>
    | Verification({unique: true}) => <> </>
    | Verification({unique: false}) =>
      <ReactTooltip
        anchorSelect="#brightid-link-status" openOnClick=true closeOnEsc=true variant={Warning}>
        <div className="flex flex-col justify-center items-center">
          <p className="text-white text-sm font-semibold">
            {"This Bright ID does not meet the requirements for a unique human"->React.string}
          </p>
        </div>
      </ReactTooltip>
    }
  }
}

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

    <div className="h-full">
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
        className="absolute rotate-90 overflow-visible"
        style={{
          marginTop: -size->Int.toString,
        }}>
        <Motion.Circle
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

module OptionItem = {
  @react.component
  let make = (~option, ~index, ~handleVote) => {
    let {queryParams, setParams} = Routes.Main.Question.Route.useQueryParams()

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
      className={`outline-none relative font-semibold text-sm my-3 pl-2 w-full flex items-center text-left backdrop-blur-md transition-all duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg bg-default lg:bg-secondary hover:lg:scale-105 focus:lg:scale-105`}
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
      {switch queryParams.answer {
      | Some(answer) if answer == index => <CircleProgress progress size=25 />
      | _ =>
        <div
          className="pointer-events-none w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-dark lg:text-primary-dark px-3 rounded-l-lg overflow-hidden">
          {(index + 65)->String.fromCharCode->React.string}
        </div>
      }}
      <button
        className={`focus:outline-none w-full  flex flex-row items-center lg:my-2 first:mb-2 py-2   px-2 min-h-[80px] overflow-hidden  transition-all`}
        key={index->Int.toString}>
        <p className="pointer-events-none"> {option->React.string} </p>
      </button>
    </li>
  }
}

module OptionsPage = {
  module Fragment = %relay(`
    fragment SingleQuestion_OptionsPage_question on Question {
      options
    }
  `)
  @react.component
  let make = (~question) => {
    let {options} = Fragment.useOpt(question)->Option.getWithDefault({options: []})
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
        let privateKey = await Jose.importPKCS8(
          privateKey,
          ~alg=ES256,
          ~options={extractable: true},
        )

        let jwt = await signAnswer(~answer=optionIndex, ~day=Date.now(), jwk, privateKey)

        Dom.Storage2.localStorage->Dom.Storage2.setItem("votesdev_answer_jwt", jwt)

        Dom.Storage2.localStorage->Dom.Storage2.setItem(
          "votes_answer_timestamp",
          Date.now()->Float.toString,
        )

        setParams(~navigationMode_=Push, ~removeNotControlledParams=false, ~setter=c => {
          ...c,
          answer: None,
        })
      | _ => window->Window.alert("Error generating client keys")
      }
    }

    <>
      <h1
        className="text-2xl px-4 pt-2 text-default-dark lg:text-primary-dark text-center animate-typewriter">
        {(queryParams.answer->Option.isSome ? "Hold to Confirm" : "Pick an answer")->React.string}
      </h1>
      <ul className="flex flex-col justify-between items-start lg:px-6 mb-4 lg:mr-4">
        {options
        ->Array.mapWithIndex((option, index) =>
          <OptionItem key={index->Int.toString} option index handleVote />
        )
        ->React.array}
      </ul>
      <div className="flex flex-col justify-center items-center mb-6 gap-3" />
    </>
  }
}

module AnswerPage = {
  module Query = %relay(`
  query SingleQuestion_AnswerPage_Query {
    answer {
      __typename
    }
  }
`)

  module Fragment = %relay(`
  fragment SingleQuestion_AnswerPage_question on Question {
    options
  }`)

  @react.component
  let make = (~question) => {
    let _ = Query.use(~variables=())
    let {options} = Fragment.useOpt(question)->Option.getWithDefault({options: []})
    let (answer, setAnswer) = React.useState(_ => None)

    React.useEffect0(() => {
      let getAnswerFromJWT = async () => {
        let jwt =
          Dom.Storage2.localStorage->Dom.Storage2.getItem("votesdev_answer_jwt")->Option.getExn
        let header = Jose.JWT.Verify.decodeProtectedHeader(jwt)
        let importedPubKey = await Jose.importJWK(header.jwk, ~alg=ES256)

        let answer = await Jose.JWT.Verify.make(jwt, importedPubKey)
        setAnswer(_ => Some(answer))
      }
      getAnswerFromJWT()->ignore
      None
    })

    switch answer {
    | None => React.null
    | Some(answer) =>
      switch options->Array.get(answer.payload["answer"]) {
      | Some(option) => <div> {`✅  ${option}`->React.string} </div>
      | None => <div> {"Error: Invalid answer"->React.string} </div>
      }
    }
  }
}

module Query = %relay(`
  query SingleQuestionQuery($id: ID!) {
    node(id: $id) {
      ...SingleQuestion_node
    }
  }
`)

module Fragment = %relay(`
  fragment SingleQuestion_node on Question {
    id
    ...SingleQuestion_OptionsPage_question
    ...SingleQuestion_QuestionTitle_question
    ...SingleQuestion_AnswerPage_question
  }
`)

@react.component @relay.deferredComponent
let make = (
  ~queryRef=?,
  ~question: option<RescriptRelay.fragmentRefs<[#BottomNav_question | #SingleQuestion_node]>>=?,
) => {
  let {queryParams} = Routes.Main.Question.Route.useQueryParams()
  let (hasAnswered, setHasAnswered) = React.useState(_ => false)
  let answerRef = React.useCallback0(element => {
    switch element->Nullable.toOption {
    | Some(element) =>
      element->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: End})
    | None => ()
    }
  })

  let data = queryRef->Option.map(queryRef => Query.usePreloaded(~queryRef))

  let question = Fragment.useOpt(question)

  let node = switch data {
  | Some({node: Some({fragmentRefs})}) => Some(fragmentRefs)
  | _ => None
  }

  let node = node->Fragment.useOpt

  let question = node->Option.orElse(question)
  let {setHeroComponent} = React.useContext(HeroComponentContext.context)
  let votesy = React.useContext(VotesySpeakContext.context)

  let asker = "0xf4bb53eFcFd49Fe036FdCc8F46D981203ae3BAB8"

  React.useEffect0(() => {
    setHeroComponent(_ =>
      <div
        className="flex flex-col justify-center items-center w-full p-4 h-[420px] min-h-[420px]"
        ref={ReactDOM.Ref.callbackDomRef(answerRef)}>
        <QuestionTitle question={question->Option.map(q => q.fragmentRefs)} />
        <div
          className=" flex justify-around w-full text-xl font-semibold text-default-darker pt-10 text-center">
          <div />
          <React.Suspense fallback={<div />}>
            <ShortAddress address=Some(asker) avatar=true />
          </React.Suspense>
        </div>
      </div>
    )
    votesy.setContent(_ => "It's your first vote! Pick an answer and start your streak!")

    None
  })

  React.useEffect1(() => {
    setHasAnswered(_ => {
      open Dom.Storage2
      switch localStorage->getItem("votesdev_answer_jwt") {
      | Some("") => false
      | Some(_) => true
      | None => false
      }
    })
    None
  }, [queryParams.answer])

  hasAnswered
    ? <AnswerPage question={question->Option.map(q => q.fragmentRefs)} />
    : <OptionsPage question={question->Option.map(q => q.fragmentRefs)} />
}
