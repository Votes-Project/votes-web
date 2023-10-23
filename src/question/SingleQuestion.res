type choice = {
  value: string,
  correct: bool,
  details: string,
}
let longTitle = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu?"
let choices = [
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

module ChoicesPage = {
  @react.component
  let make = (~handleVote) => {
    <>
      <h1 className="text-2xl px-4 pt-2 text-default-dark lg:text-primary-dark text-center">
        {"Pick an answer"->React.string}
      </h1>
      <ul className="flex flex-col justify-between items-start lg:px-6 mb-4 lg:mr-4">
        {choices
        ->Array.mapWithIndex((option, i) => {
          <li
            className={`font-semibold text-sm my-3 pl-2 w-full flex items-center text-left backdrop-blur-md transition-all duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg bg-default lg:bg-secondary hover:translate-x-5 `}
            key={i->Int.toString}>
            <div
              className="w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-dark lg:text-primary-dark px-3 rounded-l-lg overflow-hidden">
              {(i + 65)->String.fromCharCode->React.string}
            </div>
            <button
              className={`w-full  flex flex-row items-center  my-4 lg:my-2 first:mb-2 py-2   px-2 min-h-[80px] overflow-hidden  transition-all`}
              key={i->Int.toString}
              onClick={handleVote(_, i)}>
              {option.value->React.string}
            </button>
          </li>
        })
        ->React.array}
      </ul>
      <div className="flex flex-col justify-center items-center mb-6 gap-3" />
    </>
  }
}

module AnswerPage = {
  @react.component
  let make = (~chosenIndex) => {
    let selectedChoice = chosenIndex->Option.flatMap(i => choices->Array.get(i))

    <div className="flex flex-col max-h-full w-full">
      <div className="w-full flex flex-col justify-center items-center h-1/2">
        <div className="w-full text-center"> {"Preview"->React.string} </div>
        <EmptyVoteChart className="" />
        <div
          className={`w-full flex flex-row items-centerpy-8 px-4 rounded-lg max-w-md bg-active text-white`}>
          <label className="font-semibold">
            {selectedChoice
            ->Option.mapWithDefault("Other", selectedChoice => selectedChoice.value)
            ->React.string}
          </label>
        </div>
      </div>
      <div className="flex flex-col justify-between items-start px-6 ">
        <button
          className={`w-full  flex flex-row items-center  my-2 first:mb-2 py-2  rounded-lg px-4 min-h-[80px] overflow-hidden transition-all`}
          onClick={_ => {
            ()
          }}>
          <p className={`font-semibold text-left`}> {"Confirm"->React.string} </p>
        </button>
      </div>
    </div>
  }
}

@react.component @relay.deferredComponent
let make = () => {
  let {setHeroComponent} = React.useContext(HeroComponentContext.context)
  let (chosenIndex, setChosenIndex) = React.useState(_ => None)

  React.useEffect0(() => {
    setHeroComponent(_ =>
      <div className="flex justify-center items-center w-full p-4 h-[558px] min-h-[558px] ">
        <QuestionTitle />
      </div>
    )
    None
  })

  let handleVote = (_, i) => {
    setChosenIndex(_ => Some(i))
    Dom.Storage2.localStorage->Dom.Storage2.setItem(
      "votes_answer_timestamp",
      Date.now()->Float.toString,
    )
  }

  {
    chosenIndex->Option.isSome ? <AnswerPage chosenIndex /> : <ChoicesPage handleVote />
  }
}
