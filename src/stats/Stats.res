@module external brightidLogo: 'a = "/assets/brightid-white.svg"

module Alert = {
  @react.component
  let make = () => {
    <div
      className="absolute top-[-2px] right-[-2px] font-fugaz flex justify-center items-center w-4 h-4 rounded-full bg-active text-white text-xs animate-pulse">
      {"!"->React.string}
    </div>
  }
}

module BrightIdBento = {
  @react.component
  let make = () => {
    let {verification} = React.useContext(VerificationContext.context)

    switch verification {
    | Some(Verification({unique: true})) =>
      <div className="mb-2 lg:mb-4 rounded-xl border-2 border-green-400 bg-green-100 p-1">
        <div className="flex items-center gap-2">
          <BrightIdWhiteSVG
            className="self-end align-start lg:align-end w-8 h-8 p-1 lg:w-10 lg:h-10 fill-green-500"
          />
          <h1 className="text-lg lg:text-2xl font-fugaz align-bottom">
            {"BrightID"->React.string}
          </h1>
        </div>
        <p className="text-green-500 font-fugaz text-2xl lg:text-4xl p-1 text-center">
          {"Verified"->React.string}
        </p>
      </div>
    | Some(Verification({unique: false})) =>
      <div className="mb-2 lg:mb-4 rounded-xl border-2 border-yellow-400 bg-red-100 p-1">
        <div className="flex items-center gap-2">
          <BrightIdWhiteSVG
            className="self-end align-start lg:align-end w-8 h-8 p-1 lg:w-10 lg:h-10 fill-red-500"
          />
          <h1 className="text-lg lg:text-2xl font-fugaz align-bottom">
            {"BrightID"->React.string}
          </h1>
        </div>
        <p className="text-red-500 font-fugaz text-2xl lg:text-4xl p-1 text-center">
          {"Not Unique"->React.string}
        </p>
      </div>
    | Some(Error({errorNum: -1})) =>
      <div className="mb-2 lg:mb-4 rounded-xl border-2 border-red-400 bg-yellow-100 p-1">
        <div className="flex items-center gap-2">
          <BrightIdWhiteSVG
            className="self-end align-start lg:align-end w-8 h-8 p-1 lg:w-10 lg:h-10 fill-yellow-500"
          />
          <h1 className="text-lg lg:text-2xl font-fugaz align-bottom">
            {"BrightID"->React.string}
          </h1>
        </div>
        <p className=" text-yellow-500 font-fugaz text-2xl lg:text-4xl p-1 text-center">
          {"Rate Limited"->React.string}
        </p>
      </div>
    | None =>
      <div className="mb-2 lg:mb-4 rounded-xl border-2 border-gray-400 bg-gray-100 p-1 ">
        <div className="flex items-center gap-2">
          <BrightIdWhiteSVG
            className="self-end align-start lg:align-end w-8 h-8 p-1 lg:w-10 lg:h-10 fill-gray-500 animate-spin"
          />
          <h1 className="text-lg lg:text-2xl font-fugaz align-bottom">
            {"BrightID"->React.string}
          </h1>
        </div>
        <div className=" animate-pulse bg-gray-500  h-8 rounded-lg lg:text-4xl m-1 text-center" />
      </div>
    | _ =>
      <div className="mb-2 lg:mb-4 rounded-xl border-2 border-red-400 bg-yellow-100 p-1">
        <div className="flex items-center gap-2">
          <BrightIdWhiteSVG
            className="self-end align-start lg:align-end w-12 h-12 fill-yellow-500"
          />
          <h1 className="text-lg lg:text-2xl font-fugaz align-bottom">
            {"BrightID"->React.string}
          </h1>
        </div>
        <p className="text-yellow-500 font-fugaz text-2xl lg:text-4xl p-1 text-center">
          {"Action Required"->React.string}
        </p>
      </div>
    }
  }
}

module Query = %relay(`
  query StatsQuery {
    randomQuestion {
      id
    }
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let _ = Query.usePreloaded(~queryRef)
  let (hasCopied, setHasCopied) = React.useState(_ => false)
  let keyPair = UseKeyPairHook.useKeyPair()

  let saveReferralToClipboard = contextId => {
    (Environment.publicUrl ++ `/referral=${contextId}`)->Clipboard.writeText
    setHasCopied(_ => true)
    let _ = setTimeout(() => setHasCopied(_ => false), 2000)
  }
  <>
    <header
      className="flex flex-col md:flex-row-reverse w-full justify-center items-center py-2 lg:p-6 border-b border-gray-200 gap-3">
      {switch keyPair {
      | Some({contextId}) if hasCopied =>
        <FramerMotion.Button
          layoutId="referral"
          onClick={_ => saveReferralToClipboard(contextId)}
          className="fixed top-4 left-4 md:static md:flex flex-2 md:self-end self-start justify-center items-center text-center gap-1 bg-green-200 border border-green-500 rounded-lg p-2 max-w-xs">
          <div className="flex flex-col">
            {<>
              <p className="text-sm font-black text-green-500">
                {"Copied to Clipboard"->React.string}
              </p>
              <p className="text-sm font-black hidden lg:visible">
                {contextId->String.substring(~start=0, ~end=10)->String.concat("...")->React.string}
              </p>
            </>}
          </div>
          <ReactIcons.LuCopyCheck className="text-3xl p-1 text-green-500 animate-ping" />
        </FramerMotion.Button>
      | Some({contextId}) if !hasCopied =>
        <FramerMotion.Button
          layoutId="referral"
          onClick={_ => saveReferralToClipboard(contextId)}
          className=" fixed top-4 left-4 md:static flex flex-2 md:self-end self-start justify-center items-center text-center gap-1 bg-neutral-100 border border-default-darker rounded-lg p-2 max-w-xs">
          <div className="flex flex-col">
            {<>
              <p className="text-sm font-black  text-default-darker">
                {"Votes Referral Link"->React.string}
              </p>
              <p className="text-sm font-black hidden lg:visible">
                {contextId->String.substring(~start=0, ~end=10)->String.concat("...")->React.string}
              </p>
            </>}
          </div>
          <ReactIcons.LuCopy className="text-3xl p-1" />
        </FramerMotion.Button>
      | _ => <> </>
      }}
      <h1
        className="text-3xl flex-1 lg:text-3xl font-semibold text-default-light lg:text-default-darker">
        {"Voter Stats"->React.string}
      </h1>
    </header>
    <div className=" w-full  flex flex-col lg:flex-row justify-between p-4 lg:p-8 lg:gap-4">
      <div className="flex flex-1 flex-col text-xl ">
        <BrightIdBento />
        <div
          className="mb-2 lg:mb-4 flex-1 flex flex-col justify-center items-center rounded-xl border-2 border-slate-400/10 bg-neutral-100 p-2 ">
          <div className="flex self-start">
            <p className="self-start align-start text-xl lg:text-3xl"> {"🦉"->React.string} </p>
            <p className="text-lg lg:text-2xl font-fugaz align-bottom">
              {"Points"->React.string}
            </p>
          </div>
          <div
            className="font-fugaz text-3xl lg:text-5xl text-center flex-1 flex items-center justify-center">
            {"000"->React.string}
          </div>
        </div>
      </div>
      <div className="flex flex-1 flex-col text-xl font-fugaz">
        <div className="flex flex-row justify-center items-center gap-2">
          <div
            className="mb-2 max-w-sm flex-1 text-center lg:mb-4 rounded-xl border-2 border-slate-400/10 bg-neutral-100 p-2 lg:p-3">
            <div className="flex  gap-2">
              <p className="self-start align-start text-xl lg:text-3xl"> {"🔥"->React.string} </p>
              <p className="text-lg lg:text-2xl align-bottom"> {"Streak"->React.string} </p>
            </div>
            <p className="text-2xl lg:text-4xl self-center"> {"000 Days"->React.string} </p>
          </div>
        </div>
        <div className="flex flex-row text-xl justify-between gap-2">
          <div
            className="flex flex-1 w-2/5 flex-col justify-around items-center mb-2 lg:mb-4 rounded-xl self-center border-2 border-slate-400/10 bg-neutral-100  p-2 lg:p-4">
            <p className="text-lg lg:text-xl"> {"Referrals"->React.string} </p>
            <p className="text-xl lg:text-4xl self-center"> {"000"->React.string} </p>
          </div>
          <div
            className="flex flex-1 w-2/5 flex-col justify-around items-center mb-2 lg:mb-4  rounded-xl border-2 border-slate-400/10 bg-neutral-100 p-2 lg:p-4">
            <p className="text-lg lg:text-xl"> {"Bids"->React.string} </p>
            <p className="text-xl lg:text-4xl self-center"> {"000"->React.string} </p>
          </div>
        </div>
        <div className="text-center flex flex-row text-xl justify-between gap-2">
          <div
            className=" flex flex-1 w-2/5 flex-col justify-around items-center mb-2 lg:mb-4 rounded-xl self-center border-2 border-slate-400/10 bg-neutral-100 p-2 lg:p-4">
            <p className="text-lg lg:text-xl"> {"Answers"->React.string} </p>
            <p className="text-xl lg:text-4xl self-center"> {"000"->React.string} </p>
          </div>
          <div
            className="flex flex-1 w-2/5 flex-col justify-around items-center mb-2 lg:mb-4  rounded-xl border-2 border-slate-400/10 bg-neutral-100 p-2 lg:p-4">
            <p className="text-lg lg:text-xl"> {"Votes"->React.string} </p>
            <p className="text-xl lg:text-4xl self-center"> {"000"->React.string} </p>
          </div>
        </div>
      </div>
    </div>
  </>
}
