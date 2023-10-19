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
    } else if titleLength <= 100 {
      "text-2xl"
    } else if titleLength <= 150 {
      "text-xl"
    } else if titleLength <= 200 {
      "text-lg"
    } else {
      "text-md"
    }
  }

  let title = longTitle
  @react.component
  let make = () => {
    open FramerMotion
    <div className="">
      <div
        className="w-full h-0 border mb-4 bg-black border-default-darker rounded-md opacity-10"
      />
      <Motion.Div
        layoutId="daily-question-preview"
        className={`font-bold [text-wrap:balance] text-center text-default-darker px-4  ${titleStyle(
            title->String.length,
          )}`}>
        {("\"" ++ title ++ "\"")->React.string}
      </Motion.Div>
      <div
        className="w-full h-0 border my-4 bg-black border-default-darker rounded-md opacity-10"
      />
    </div>
  }
}
module QuestionHeader = {
  @react.component
  let make = () => {
    <div className="flex flex-col items-center">
      <div
        className="font-semibold flex w-full justify-between items-center py-4 px-4 max-w-2xl text-sm">
        <p className="text-default-darker"> {"August 5 2023"->React.string} </p>
        <div
          className="mx-3 max-w-[36px] h-0 flex-1 border-2 bg-black  border-default-darker rounded-md"
        />
        <ShortAddress address=Some("0x1234567890123456789012345678901234567890") />
        <div
          className="mx-3 max-w-[36px] h-0 flex-1 border-2 bg-black border-default-darker rounded-md"
        />
        <p className="text-default-darker"> {"1000 Answers"->React.string} </p>
      </div>
      <QuestionTitle />
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
    open DailyQuestion_verification_graphql
    switch verificationData {
    | Types.Error(_) =>
      <ReactTooltip anchorSelect="#brightid-link-status">
        <div className="flex flex-col justify-center items-center">
          <p className="text-white text-sm font-semibold">
            {"Link Votes to Bright ID"->React.string}
          </p>
        </div>
      </ReactTooltip>
    | VerificationData({unique: true}) => <> </>
    | VerificationData({unique: false}) =>
      <ReactTooltip
        anchorSelect="#brightid-link-status" openOnClick=true closeOnEsc=true variant={Warning}>
        <div className="flex flex-col justify-center items-center">
          <p className="text-white text-sm font-semibold">
            {"This Bright ID does not meet the requirements for a unique human"->React.string}
          </p>
        </div>
      </ReactTooltip>
    | _ => React.null
    }
  }
}

module ChoicesPage = {
  let titleStyle = titleLength => {
    if titleLength <= 50 {
      "text-3xl"
    } else if titleLength <= 100 {
      "text-xl"
    } else if titleLength <= 150 {
      "text-lg"
    } else if titleLength <= 200 {
      "text-md"
    } else {
      "text-md"
    }
  }

  @react.component
  let make = (~chosenIndex, ~handleChecked, ~handleVote) => {
    React.useEffect0(() => {
      Dom.Storage2.localStorage->Dom.Storage2.setItem(
        "votes_question_timestamp",
        Date.now()->Float.toString,
      )
      None
    })

    let choiceStyle = i =>
      chosenIndex == Some(i)
        ? "bg-active text-white shadow border border-active"
        : "text-default-darker shadow-inner bg-secondary border border-primary "

    <>
      <div className="flex flex-col justify-between items-start px-6 mb-4 mr-4">
        {choices
        ->Array.mapWithIndex((option, i) => {
          <button
            className={`w-full  flex flex-row items-center  my-2 first:mb-2 py-2  rounded-lg px-4 min-h-[80px] overflow-hidden ${choiceStyle(
                i,
              )} transition-all`}
            key={i->Int.toString}
            onClick={_ => {
              handleChecked(i)
            }}>
            <p className={`font-semibold text-left`}> {option.value->React.string} </p>
          </button>
        })
        ->React.array}
      </div>
      <div className="flex flex-col justify-center items-center mb-6 gap-3">
        <div className="flex flex-row w-[80%] items-center justify-around px-10">
          <button
            className="py-2 px-8 bg-active text-white rounded-lg text-2xl font-bold disabled:bg-default-disabled disabled:opacity-50"
            onClick={_ => handleVote()}>
            {{chosenIndex->Option.isSome ? "Vote" : "Other"}->React.string}
          </button>
        </div>
      </div>
    </>
  }
}

type answerStatus = Ethereum | BrightID | EthereumBrightID

type answerStatusOption<'a> = {
  status: option<answerStatus>,
  text: string,
  action: 'a => unit,
}

module AnswerPage = {
  let answerStatuses = [
    {status: None, text: "Answer without Credentials", action: () => ()},
    {status: Some(Ethereum), text: "Minted", action: () => ()},
    {status: Some(BrightID), text: "Verified", action: () => ()},
    {
      status: Some(EthereumBrightID),
      text: "Minted and Verified",
      action: () => (),
    },
  ]

  module VerificationFragment = %relay(`
  fragment DailyQuestion_verification on Verification {
    ... on VerificationData {
      id
      unique
      contextIds
    }
    ... on Error {
      error
    }
  }`)

  @react.component
  let make = (~chosenIndex, ~verification) => {
    let selectedChoice = chosenIndex->Option.flatMap(i => choices->Array.get(i))
    let (answerChoiceIndex, setAnswerChoiceIndex) = React.useState(_ => None)
    let {address} = Wagmi.UseAccount.make()
    let {openConnectModal} = RainbowKit.useConnectModal()
    let {openAccountModal} = RainbowKit.useAccountModal()
    let keys = UseKeyPairHook.useKeyPair()
    let {setParams} = Routes.Main.Route.useQueryParams()

    let verificationData = VerificationFragment.use(verification)

    let setLinkBrightID = linkBrightID => {
      setParams(
        ~removeNotControlledParams=false,
        ~navigationMode_=Push,
        ~shallow=false,
        ~setter=c => {
          ...c,
          linkBrightID,
          contextId: keys->Option.map(({contextId}) => contextId),
        },
      )
    }
    let handleBrightIDClick = (_, verificationData) => {
      open DailyQuestion_verification_graphql
      switch verificationData {
      | Types.Error(_) => setLinkBrightID(Some(0))
      | VerificationData({unique: true}) => ()
      | VerificationData({unique: false}) => ()
      | _ => setLinkBrightID(Some(0))
      }
    }
    let handleEthereumClick = _ => {
      switch address->Nullable.toOption {
      | None => openConnectModal()
      | Some(_) => openAccountModal()
      }
    }

    let choiceStyle = i =>
      answerChoiceIndex == Some(i)
        ? "bg-active text-white shadow border border-active"
        : "text-default-darker shadow-inner bg-secondary border border-primary "

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
        {answerStatuses
        ->Array.mapWithIndex((option, i) => {
          <button
            className={`w-full  flex flex-row items-center  my-2 first:mb-2 py-2  rounded-lg px-4 min-h-[80px] overflow-hidden ${choiceStyle(
                i,
              )} transition-all`}
            key={i->Int.toString}
            onClick={_ => {
              setAnswerChoiceIndex(_ => Some(i))
            }}>
            <p className={`font-semibold text-left`}> {option.text->React.string} </p>
          </button>
        })
        ->React.array}
      </div>
      <LinkStatusTooltip verificationData />
      <button
        id="brightid-link-status"
        className="align-middle"
        onClick={e => handleBrightIDClick(e, verificationData)}
      />
      <button className="align-middle " onClick=handleEthereumClick />
    </div>
  }
}

module Query = %relay(`
  query DailyQuestionQuery($contextId: String!) {
    verification(contextId: $contextId) {
      ...DailyQuestion_verification
    }
  }`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let {verification} = Query.usePreloaded(~queryRef)

  let (chosenIndex, setChosenIndex) = React.useState(_ => None)
  let (hasAnswered, setHasAnswered) = React.useState(_ => false)

  let handleChecked = index => {
    if Some(index) == chosenIndex {
      setChosenIndex(_ => None)
    } else {
      setChosenIndex(_ => Some(index))
    }
  }
  let handleVote = _ => {
    setHasAnswered(_ => true)
  }

  {
    hasAnswered
      ? <AnswerPage chosenIndex verification={verification.fragmentRefs} />
      : <ChoicesPage chosenIndex handleChecked handleVote />
  }
}
