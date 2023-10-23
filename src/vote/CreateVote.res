module ContentEditable = {
  @react.component @module("react-contenteditable")
  external make: (
    ~onChange: 'a => unit=?,
    ~onBlur: 'a => unit=?,
    ~html: string,
    ~disabled: bool=?,
    ~className: string=?,
    ~onFocus: 'a => unit=?,
    ~editablehasplaceholder: string=?,
    ~placeholder: string=?,
  ) => React.element = "default"
}

module Clipboard = {
  @scope(("navigator", "clipboard"))
  external writeText: string => unit = "writeText"
}

module SanitizeHtml = {
  type config<'a> = {
    allowedAttributes: 'a,
    allowedTags: array<string>,
  }
  @module("sanitize-html") external make: (string, config<'a>) => string = "default"
}

type changeTextActions =
  | ChangeChoice({index: int, value: string})
  | ChangeTitle(string)

type action =
  | ...changeTextActions
  | AddChoice
  | RemoveChoice(int)
  | MaxChoicesReached

type state = {title: string, choices: array<string>}

let makeDiscordCommand = (title, choices) => {
  let command = "/poll"

  let question = `question:${title}`

  let answers = choices->Array.mapWithIndex((choice, i) => {
    `answer${(i + 1)->Int.toString}:${choice}`
  })

  command ++ " " ++ question ++ " " ++ answers->Array.joinWith(" ")
}

let reducer = (state, action) => {
  switch action {
  | AddChoice => {
      ...state,
      choices: state.choices->Array.concat([""]),
    }
  | RemoveChoice(indexToRemove) => {
      ...state,
      choices: state.choices->Array.filterWithIndex((_, i) => indexToRemove !== i),
    }
  | ChangeChoice({index, value}) =>
    let choices = state.choices->Array.mapWithIndex((choice, i) => {
      i === index ? value : choice
    })
    {...state, choices}

  | MaxChoicesReached => state
  | ChangeTitle(value) => {...state, title: value}
  }
}

let initialState = {
  title: "",
  choices: ["", ""],
}

let maxChoices = 5

@react.component @relay.deferredComponent
let make = (~children) => {
  let titleRef = React.useRef("")
  let ({choices, title}, dispatch) = React.useReducer(reducer, initialState)

  let choiceCount = choices->Array.length
  let {setHeroComponent} = React.useContext(HeroComponentContext.context)

  React.useEffect0(() => {
    window->Window.ScrollTo.makeWithOptions({top: 0, behavior: Smooth})
    None
  })

  let onTitleChange = e => {
    open SanitizeHtml
    let sanitizeConfig = {
      allowedTags: ["b", "i", "em", "strong", "a", "p", "h1"],
      allowedAttributes: {"a": ["href"]},
    }

    titleRef.current = SanitizeHtml.make((e->ReactEvent.Form.target)["value"], sanitizeConfig)

    ChangeTitle(titleRef.current)->dispatch
  }
  let onChoiceChange = (e, i) => {
    open SanitizeHtml
    let sanitizeConfig = {
      allowedTags: ["b", "i", "em", "strong", "a", "p", "h1"],
      allowedAttributes: {"a": ["href"]},
    }
    let sanitizedContent = SanitizeHtml.make((e->ReactEvent.Form.target)["value"], sanitizeConfig)

    ChangeChoice({index: i, value: sanitizedContent})->dispatch
  }

  let handleAddChoice = _ => {
    if choiceCount < 5 {
      AddChoice->dispatch
    } else {
      MaxChoicesReached->dispatch
    }
  }

  let handleRemoveChoice = (_, index) => {
    if choiceCount > 2 {
      RemoveChoice(index)->dispatch
    }
  }

  let saveCommandToClipboard = () => {
    makeDiscordCommand(titleRef.current, choices)->Clipboard.writeText
  }

  let canSubmit =
    choiceCount >= 2 &&
    !(title->String.trim->String.equal("")) &&
    choices->Array.every(choice => !(choice->String.trim->String.equal("")))

  React.useEffect1(() => {
    setHeroComponent(_ =>
      <div className="flex justify-center items-start w-full p-4 h-[558px] min-h-[558px]  ">
        <div
          className="h-full flex-1 relative flex  bg-transparent focus-within:border-2 focus-within:ring-0 focus-within:border-primary backdrop-blur-[2px] rounded-lg transition-all duration-200 ease-linear">
          <ContentEditable
            editablehasplaceholder="true"
            placeholder="Ask a question..."
            html=titleRef.current
            onChange={onTitleChange}
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
          <ol className="flex flex-col justify-start items-start flex-1 ">
            {choices
            ->Array.mapWithIndex((_, index) => {
              <li
                key={Int.toString(index)}
                className="relative pr-10 my-3 w-full flex items-center border-2 text-left lg:border-primary border-default backdrop-blur-md transition-all duration-200 ease-linear rounded-xl">
                <div
                  className="w-9 flex items-center justify-center relative font-bold text-2xl h-full text-default-dark lg:text-primary-dark bg-default lg:bg-primary px-3 rounded-l-lg border-default-dark lg:border-primary border-r-2 overflow-hidden ">
                  <p className="z-10 "> {(index + 65)->String.fromCharCode->React.string} </p>
                </div>
                <ContentEditable
                  editablehasplaceholder="true"
                  placeholder="Option..."
                  html={choices[index]->Option.getWithDefault("")}
                  onChange={onChoiceChange(_, index)}
                  className="w-[90%]  max-w-full break-all border-none focus:ring-0 bg-transparent cursor-pointer h-full placeholder:text-center focus:cursor-text min-h-[3.5rem]"
                />
                <button
                  type_="button"
                  onClick={handleRemoveChoice(_, index)}
                  className=" absolute flex right-0  items-center justify-center text-default-dark font-bold text-3xl h-10 w-10 hover:scale-125 hover:default transition-all duration-200 ease-linear">
                  <ReactIcons.LuSettings size="1.5rem" className="text-default-darker  " />
                </button>
              </li>
            })
            ->React.array}
          </ol>
          <div className="text-center pl-4 flex flex-col-reverse">
            <button
              className="w-4 font-bold font-fugaz text-4xl pb-5 hover:scale-125 transition-all duration-300 ease-linear"
              type_="button"
              onClick={handleAddChoice}>
              {{choiceCount < maxChoices ? "+" : ""}->React.string}
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
          className="m-auto disabled:bg-default-disabled disabled:text-default-darker/50 disabled:scale-100 disabled:border-none rounded-xl p-4 max-w-xs self-center font-semibold hover:border-2 border-default-dark bg-default-dark text-white lg:border-primary transition-all ease-linear hover:scale-105 hover:backdrop-blur-sm ">
          {"Generate Discord Command"->React.string}
        </button>
      </form>
      {children}
    </div>
  </div>
}
