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
    <div className="px-12">
      <div
        className="w-full h-0 border mb-4 bg-black border-default-darker rounded-md opacity-10"
      />
      <h2
        className={`font-bold [text-wrap:balance] text-center text-default-darker px-4  ${titleStyle(
            title->String.length,
          )}`}>
        {("\"" ++ title ++ "\"")->React.string}
      </h2>
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
  let make = (~verification, ~checkedIndex, ~handleChecked, ~handleVote) => {
    let {address} = Wagmi.useAccount()
    let {openConnectModal} = RainbowKit.useConnectModal()
    let {openAccountModal} = RainbowKit.useAccountModal()
    let {setParams} = Routes.Main.Route.useQueryParams()
    let keys = UseKeyPairHook.useKeyPair()

    let verificationData = VerificationFragment.use(verification)

    // React.useEffect2(() => {
    //   switch verificationData {
    //   | VerificationData(verificationData) => {
    //       open VerificationContext
    //       let contextId =
    //         verificationData.contextIds->Array.get(0)->Option.map(Uint8Array.from)->Option.getExn
    //       let isVerified = verificationData.unique
    //       setVerification(_ => Some({contextId, isVerified}))
    //       None
    //     }
    //   | BrightIdError(_) =>
    //     setVerification(_ => Some({contextId: publicKey, isVerified: false}))
    //     None

    //   | _ => None
    //   }
    // }, (setVerification, queryParams))
    let choiceStyle = i =>
      checkedIndex == Some(i)
        ? "bg-active text-white shadow border border-active"
        : "text-default-darker shadow-inner bg-secondary border border-primary "

    let brightIDImageStyle = verificationData => {
      open DailyQuestion_verification_graphql
      switch verificationData {
      | Types.Error(_) => "filter grayscale"
      | VerificationData({unique: true}) => ""
      | VerificationData({unique: false}) => "filter grayscale bg-red-500"
      | _ => "filter grayscale"
      }
    }

    let ethereumImageStyle = address =>
      switch address->Nullable.toOption {
      | None => "filter grayscale"
      | Some(_) => ""
      }

    let handleEthereumClick = _ => {
      switch address->Nullable.toOption {
      | None => openConnectModal()
      | Some(_) => openAccountModal()
      }
    }

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
        <button
          className="text-background-dark
              font-semibold
              underline
            ">
          {"None of the Above"->React.string}
        </button>
        <div className="flex flex-row w-[80%] items-center justify-around px-10">
          <LinkStatusTooltip verificationData />
          <button
            id="brightid-link-status"
            className="align-middle"
            onClick={e => handleBrightIDClick(e, verificationData)}>
            <img
              className={`w-[48px] ${brightIDImageStyle(verificationData)}`}
              src={"https://unitap.app/assets/images/navbar/bright-icon.svg"}
            />
          </button>
          <button
            className="py-2 px-8 bg-active text-white rounded-lg text-2xl font-bold disabled:bg-default-disabled disabled:opacity-50"
            disabled={checkedIndex->Option.isNone}
            onClick={_ => handleVote()}>
            {"Vote"->React.string}
          </button>
          <button className="align-middle " onClick=handleEthereumClick>
            <img
              className={`w-[48px] hover:drop-shadow-glow ${ethereumImageStyle(address)}`}
              src="https://ethereum.org/static/2aba39d4e25d90caabb0c85a58c6aba9/d5a11/eth-glyph-colored.webp"
            />
          </button>
        </div>
      </div>
    </>
  }
}

module AnswerPage = {
  @react.component
  let make = (~checkedIndex) => {
    let selectedChoice = checkedIndex->Option.flatMap(i => choices->Array.get(i))

    <>
      <div
        className={`w-full flex flex-row items-center my-4 py-8 px-4 rounded-lg max-w-md bg-active text-white`}>
        <label className="font-semibold">
          {Option.getExn(selectedChoice).value->React.string}
        </label>
      </div>
    </>
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

  let (checkedIndex, setCheckedIndex) = React.useState(_ => None)
  let (hasAnswered, setHasAnswered) = React.useState(_ => false)

  let handleChecked = index => {
    setCheckedIndex(_ => Some(index))
  }
  let handleVote = _ => {
    setHasAnswered(_ => true)
  }

  {
    hasAnswered
      ? <AnswerPage checkedIndex />
      : <ChoicesPage
          verification={verification.fragmentRefs} checkedIndex handleChecked handleVote
        />
  }
}
