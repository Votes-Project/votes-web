@val @scope(("import", "meta", "env"))
external questionsContractAddress: option<string> = "VITE_QUESTIONS_CONTRACT_ADDRESS"

module Clipboard = {
  @scope(("navigator", "clipboard"))
  external writeText: string => unit = "writeText"
}

let makeDiscordCommand = (title, options: array<AskContext.questionOption>) => {
  let command = "/poll"

  let question = `question:${title}`

  let answers = options->Array.mapWithIndex((option, i) => {
    `answer${(i + 1)->Int.toString}:${option.option->Option.getExn}`
  })

  command ++ " " ++ question ++ " " ++ answers->Array.joinWith(" ")
}

let maxOptions = 5

@react.component @relay.deferredComponent
let make = (~children) => {
  let {setParams, queryParams} = Routes.Main.Question.Ask.Route.useQueryParams()

  let (state, dispatch) = React.useReducer(
    AskContext.reducer,
    AskContext.parseHexState(queryParams.hexState),
  )

  let askRef = React.useCallback0(element => {
    switch element->Nullable.toOption {
    | Some(element) =>
      element->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: End})
    | None => ()
    }
  })

  React.useEffect1(() => {
    let hexState = state->JSON.stringifyAny->Option.map(Viem.toHexFromString)
    setParams(~navigationMode_=Replace, ~removeNotControlledParams=false, ~setter=c => {
      ...c,
      hexState,
    })
    None
  }, [state])

  // let {config} = Wagmi.usePrepareContractWrite(
  //   ~config={
  //     address: questionsContractAddress->Belt.Option.getExn,
  //     abi: auctionContractAbi,
  //     functionName: "createBid",
  //     value: bidAmount->Viem.parseEther->Option.getWithDefault(BigInt.fromString("0")),
  //     args: [auction.tokenId],
  //   },
  // )
  // let createBid = Wagmi.useContractWrite({
  //   ...config,
  //   onSuccess: _ => {
  //     setBidAmount(_ => "")
  //   },
  // })

  // let handleCreateBid = () =>
  //   switch createBid.write {
  //   | Some(createBid) => createBid()
  //   | None => raise(ContractWriteDoesNotExist)
  // }

  let titleRef = React.useRef("")

  let {options, title} = state

  let {setHeroComponent} = React.useContext(HeroComponentContext.context)

  let onTitleChange = e => {
    open SanitizeHtml
    let sanitizeConfig = {
      allowedTags: ["b", "i", "em", "strong", "a", "p", "h1"],
      allowedAttributes: {"a": ["href"]},
    }

    titleRef.current = SanitizeHtml.make((e->ReactEvent.Form.target)["value"], sanitizeConfig)

    ChangeTitle(titleRef.current)->dispatch
  }

  let handleAddOption = _ =>
    switch Array.length(options) {
    | length if length < 5 => AddOption->dispatch
    | _ => MaxOptionsReached->dispatch
    }

  let saveCommandToClipboard = () => {
    makeDiscordCommand(titleRef.current, options)->Clipboard.writeText
  }

  let handleTitleFocus = _ => {
    open Document
    document
    ->getElementById("create-vote-title")
    ->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: Center})
  }

  let canSubmit = switch (options, title) {
  | (options, Some(_))
    if Array.length(options) >= 2 &&
      options->Array.every(({?option}) => option->Option.isSome) => true
  | _ => false
  }

  React.useEffect1(() => {
    setHeroComponent(_ =>
      <div
        className="flex flex-col items-start w-full p-4 min-h-[558px]  "
        ref={ReactDOM.Ref.callbackDomRef(askRef)}>
        <div className="w-full lg:p-4 p-2 flex flex-col items-center max-h-[50%] min-h-0 flex-1 ">
          <h2 className="text-2xl text-black opacity-60 self-start ">
            {"1. Link Token (Optional)"->React.string}
          </h2>
          {children}
        </div>
        <div
          className="lg:border-2 lg:border-primary w-full flex-1 relative flex bg-transparent focus-within:border-2 focus-within:ring-0 focus-within:border-primary backdrop-blur-[2px] rounded-lg transition-all duration-200 ease-linear">
          <ContentEditable
            id="create-vote-title"
            editablehasplaceholder="true"
            placeholder="2. Ask question..."
            html={state.title->Option.getWithDefault("")}
            onChange={onTitleChange}
            onFocus={handleTitleFocus}
            className="w-[90vw] lg:w-auto max-w-md lg:p-4 p-2 border-none focus:ring-0 break-words bg-transparent cursor-pointer text-wrap focus:cursor-text focus:text-left text-2xl transition-all duration-300 ease-linear "
          />
        </div>
      </div>
    )
    None
  }, [setHeroComponent])

  let handleAsk = _ => {
    ()
  }

  <AskContext.Provider value={state, dispatch}>
    <div className="h-full p-4 ">
      <div
        className="relative lg:p-4 w-full h-full  flex flex-col justify-around items-center lg:border-2 lg:border-primary rounded-xl ">
        <div className="flex flex-row justify-between items-center w-full">
          <ReactTooltip
            className="z-50 h-fit-content max-w-xs"
            anchorSelect="#create-vote-question"
            closeOnEsc=true
            clickable=true
            content="This will provide greater detail toward the process of asking a question. We will have to explain 3 main things. \n 1. The components of a question (Title, Answers, correct answer, further details). \n 2. Asking a question requires an unused VOTE token.  \n 3. If a vote token is not owned, your question will be turned into a Discord command that you can paste into the questions channel on Discord. "
          />
          <h2 className="text-2xl text-black opacity-60 "> {"3. Add Options"->React.string} </h2>
          <div
            id="create-vote-question"
            type_="button"
            className="flex self-end items-center justify-center text-default-dark lg:text-primary-dark font-bold text-3xl h-10 w-10 hover:scale-125 hover:default transition-all duration-200 ease-linear rounded-full">
            <ReactIcons.LuInfo className="lg:text-default-darker text-default-dark" />
          </div>
        </div>
        <div className="h-full w-full rounded-xl flex justify-start flex-col z-10 pb-4 gap-4">
          <div className="flex flex-row ">
            <AskOptions />
            <div className="text-center pl-4 flex flex-col-reverse">
              <button
                className="w-4 font-bold font-fugaz text-4xl pb-5 hover:scale-125 transition-all duration-300 ease-linear"
                type_="button"
                onClick={handleAddOption}>
                {{Array.length(options) < maxOptions ? "+" : ""}->React.string}
              </button>
            </div>
          </div>
          <ReactTooltip
            anchorSelect="#copy-discord-command"
            openOnClick=true
            clickable=true
            style={{
              backgroundColor: "transparent",
            }}>
            <a href="https://discord.gg/uwqMn3rxxj" target="_blank" rel="noopener">
              <div
                className="bg-default-dark p-4 rounded-lg flex flex-col gap-2 items-center font-bold backdrop-opacity-20 backdrop-blur-sm">
                <p className="text-center text-md text-semibold text-default-darker">
                  {"Question saved to clipboard ✔︎"->React.string}
                </p>
              </div>
            </a>
          </ReactTooltip>
          <button
            onClick=handleAsk
            disabled={!canSubmit}
            className="mb-auto min-w-[8rem] min-h-[3rem] font-bold disabled:bg-default-disabled disabled:text-default-darker disabled:opacity-50 disabled:scale-100 rounded-2xl max-w-xs self-center bg-default-darker lg:bg-active text-white transition-all ease-linear hover:scale-105  ">
            {"Ask "->React.string}
          </button>
        </div>
      </div>
    </div>
  </AskContext.Provider>
}