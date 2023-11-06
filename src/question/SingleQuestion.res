type option = {
  value: string,
  correct: bool,
  details: string,
}
let longTitle = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu?"
let options = [
  {
    value: longTitle,
    correct: true,
    details: "The answer to life, the universe and everything",
  },
  {value: longTitle, correct: false, details: "The answer to life, the universe and everything"},
  {value: longTitle, correct: false, details: "The answer to life, the universe and everything"},
  {value: longTitle, correct: false, details: "The answer to life, the universe and everything"},
  {value: "42", correct: false, details: "The answer to life, the universe and everything"},
]

ReactModal.setAppElement("#root")

module QuestionTitle = {
  let titleStyle = titleLength => {
    if titleLength <= 50 {
      "text-4xl"
    } else if titleLength <= 150 {
      "text-2xl"
    } else {
      "text-xl"
    }
  }

  let title = longTitle
  @react.component
  let make = () => {
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

module RainbowKit = {
  type useConnectModal = {openConnectModal: unit => unit}
  type useAccountModal = {openAccountModal: unit => unit}

  @module("@rainbow-me/rainbowkit")
  external useConnectModal: unit => useConnectModal = "useConnectModal"
  @module("@rainbow-me/rainbowkit")
  external useAccountModal: unit => useAccountModal = "useAccountModal"
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

module OptionItem = {
  @react.component
  let make = (~option, ~index, ~handleVote) => {
    let {queryParams, setParams} = Routes.Main.Question.Route.useQueryParams()

    let ref = React.useRef(Nullable.null)

    let handleSelect = _ => {
      setParams(~navigationMode_=Push, ~removeNotControlledParams=false, ~setter=c => {
        ...c,
        answer: Some(index),
      })
    }

    open FramerMotion
    let onDragEnd = (e, info: Drag.info) => {
      switch ref.current->Nullable.toOption {
      | Some(current) if info.offset.x > 0.8 *. current->Element.offsetWidth => handleVote(e, index)
      | _ => ()
      }
    }

    {
      switch queryParams.answer {
      | Some(answer) if answer == index =>
        <li
          className={`relative font-semibold text-sm my-3 w-full flex items-center text-left backdrop-blur-md bg-black/10 duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg  lg:scale-105 border-4 border-default-darker lg:border-active rounded-xl `}
          key={index->Int.toString}
          ref={ReactDOM.Ref.domRef(ref)}
          onClick=handleSelect>
          <Motion.Div
            drag=X
            dragConstraints=Ref(ref)
            dragSnapToOrigin=true
            dragMomentum=true
            onDragEnd
            className=" self-stretch flex flex-1 items-center justify-center relative font-bold text-3xl text-default lg:text-secondary bg-default-darker lg:bg-active px-6 rounded-lg overflow-hidden">
            {"→"->React.string}
          </Motion.Div>
          <button
            className={`relative w-full flex flex-row items-center  lg:my-2 first:mb-2 py-2 px-2 min-h-[80px] overflow-hidden transition-all  `}
            key={index->Int.toString}>
            <div
              className="absolute w-full h-full flex items-center justify-center animate-pulse text-default-darker font-bold text-3xl duration-300">
              {"Swipe to Confirm"->React.string}
            </div>
            <p className="opacity-20"> {option.value->React.string} </p>
          </button>
        </li>
      | Some(_) =>
        <li
          className={`relative font-semibold text-sm my-3 pl-2 w-full flex items-center text-left backdrop-blur-md transition-all duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg bg-default/80 lg:bg-secondary/80 hover:lg:scale-105 focus:lg:scale-105`}
          key={index->Int.toString}
          ref={ReactDOM.Ref.domRef(ref)}
          onClick=handleSelect>
          <div
            className="w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-dark lg:text-primary-dark px-3 rounded-l-lg overflow-hidden">
            {(index + 65)->String.fromCharCode->React.string}
          </div>
          <button
            className={`w-full  flex flex-row items-center lg:my-2 first:mb-2 py-2  px-2 min-h-[80px] overflow-hidden  transition-all`}
            key={index->Int.toString}>
            {option.value->React.string}
          </button>
        </li>
      | _ =>
        <li
          className={`relative font-semibold text-sm my-3 pl-2 w-full flex items-center text-left backdrop-blur-md transition-all duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg bg-default lg:bg-secondary hover:lg:scale-105 focus:lg:scale-105`}
          key={index->Int.toString}
          ref={ReactDOM.Ref.domRef(ref)}
          onClick=handleSelect>
          <div
            className="w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-dark lg:text-primary-dark px-3 rounded-l-lg overflow-hidden">
            {(index + 65)->String.fromCharCode->React.string}
          </div>
          <button
            className={`w-full  flex flex-row items-center lg:my-2 first:mb-2 py-2   px-2 min-h-[80px] overflow-hidden  transition-all`}
            key={index->Int.toString}>
            {option.value->React.string}
          </button>
        </li>
      }
    }
  }
}

module OptionsPage = {
  @react.component
  let make = () => {
    let {setParams} = Routes.Main.Question.Route.useQueryParams()
    let handleVote = (_, _) => {
      Dom.Storage2.localStorage->Dom.Storage2.setItem(
        "votes_answer_timestamp",
        Date.now()->Float.toString,
      )
      window->Window.alert("Answered")
      setParams(~navigationMode_=Push, ~removeNotControlledParams=false, ~setter=c => {
        ...c,
        answer: None,
      })
    }

    <>
      <h1 className="text-2xl px-4 pt-2 text-default-dark lg:text-primary-dark text-center">
        {"Pick an answer"->React.string}
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

module AnswerPage = {}

module AnswerPreviewPage = {
  @react.component
  let make = () => {
    let {queryParams: {answer}} = Routes.Main.Question.Current.Route.useQueryParams()
    let answer = answer->Option.flatMap(i => options->Array.get(i))

    <div className="flex flex-1 flex-col h-full w-full min-h-[558px]" id="answer-preview">
      <div className="flex-1 w-full h-full flex flex-col justify-center items-center ">
        <div
          className="flex  items-center justify-around w-full text-center text-2xl font-bold font-fugaz pb-3">
          <div className="pl-4 text-left flex-1 font-sans text-2xl font-semibold">
            {"←"->React.string}
          </div>
          <div className=""> {"Confirm"->React.string} </div>
          <div className="relative flex-1 text-sm font-sans font-normal py-5">
            <div className="align-middle"> {"🔥 10 day streak"->React.string} </div>
            <div className="absolute bottom-0 right-5 text-right">
              {"+ 1 Point"->React.string}
            </div>
          </div>
        </div>
        <div className="flex flex-col justify-between items-center flex-1 ">
          <div
            className={`w-full flex flex-row items-center p-4 rounded-lg max-w-md bg-default text-default-darker`}>
            <label className="font-semibold">
              {answer
              ->Option.mapWithDefault("Other", answer => answer.value)
              ->React.string}
            </label>
          </div>
        </div>
      </div>
    </div>
  }
}

@react.component @relay.deferredComponent
let make = () => {
  let {setHeroComponent} = React.useContext(HeroComponentContext.context)
  let votesy = React.useContext(VotesySpeakContext.context)

  let asker = "0xf4bb53eFcFd49Fe036FdCc8F46D981203ae3BAB8"

  React.useEffect0(() => {
    setHeroComponent(_ =>
      <div
        className="flex flex-col justify-center items-center w-full p-4 h-[558px] min-h-[558px] ">
        <QuestionTitle />
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

  <OptionsPage />
}
