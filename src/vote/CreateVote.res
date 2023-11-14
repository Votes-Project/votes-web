module Clipboard = {
  @scope(("navigator", "clipboard"))
  external writeText: string => unit = "writeText"
}

let makeDiscordCommand = (title, options) => {
  let command = "/poll"

  let question = `question:${title}`

  let answers = options->Array.mapWithIndex((option, i) => {
    `answer${(i + 1)->Int.toString}:${option->Option.getExn}`
  })

  command ++ " " ++ question ++ " " ++ answers->Array.joinWith(" ")
}

let maxOptions = 5

@react.component @relay.deferredComponent
let make = (~children) => {
  let askRef = React.useCallback0(element => {
    switch element->Nullable.toOption {
    | Some(element) =>
      element->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: End})
    | None => ()
    }
  })
  let titleRef = React.useRef("")
  let (state, dispatch) = React.useReducer(
    CreateVoteContext.reducer,
    CreateVoteContext.initialState,
  )

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
  | (options, Some(_)) if Array.length(options) >= 2 && options->Array.every(Option.isSome) => true
  | _ => false
  }

  React.useEffect1(() => {
    setHeroComponent(_ =>
      <div
        className="flex justify-center items-start w-full p-4 h-[558px] min-h-[558px]   "
        ref={ReactDOM.Ref.callbackDomRef(askRef)}>
        <div
          className="h-full flex-1 relative flex  bg-transparent focus-within:border-2 focus-within:ring-0 focus-within:border-primary backdrop-blur-[2px] rounded-lg transition-all duration-200 ease-linear">
          <ContentEditable
            id="create-vote-title"
            editablehasplaceholder="true"
            placeholder="Ask a question..."
            html=titleRef.current
            onChange={onTitleChange}
            onFocus={handleTitleFocus}
            className="w-[90vw] lg:w-auto max-w-lg lg:p-4 p-2 border-none focus:ring-0 break-words bg-transparent cursor-pointer text-wrap focus:cursor-text focus:text-left text-2xl transition-all duration-300 ease-linear "
          />
        </div>
      </div>
    )
    None
  }, [setHeroComponent])

  let onSubmit = e => {
    e->ReactEvent.Form.preventDefault
    saveCommandToClipboard()
  }

  <CreateVoteContext.Provider value={state, dispatch}>
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
          <h1 className="text-lg"> {"Add Options"->React.string} </h1>
          <div
            id="create-vote-question"
            type_="button"
            className="flex self-end items-center justify-center text-default-dark lg:text-primary-dark font-bold text-3xl h-10 w-10 hover:scale-125 hover:default transition-all duration-200 ease-linear rounded-full">
            <ReactIcons.LuInfo className="lg:text-default-darker text-default-dark" />
          </div>
        </div>
        <form
          className="h-full w-full rounded-xl flex justify-start flex-col z-10 pb-4 gap-4" onSubmit>
          <div className="flex flex-row ">
            <CreateVoteOptions />
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
            type_="submit"
            id="copy-discord-command"
            disabled={!canSubmit}
            className="m-auto disabled:bg-default-disabled disabled:text-default-darker disabled:opacity-50 disabled:scale-100 disabled:border-none rounded-xl p-4 max-w-xs self-center font-semibold hover:border-2 border-default-dark bg-default-dark text-white lg:border-primary transition-all ease-linear hover:scale-105 hover:backdrop-blur-sm ">
            {"Generate Discord Command"->React.string}
          </button>
        </form>
        {children}
      </div>
    </div>
  </CreateVoteContext.Provider>
}
