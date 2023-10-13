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
    state.choices->Array.set(index, value)
    state
  | MaxChoicesReached => state
  | ChangeTitle(value) => {...state, title: value}
  }
}

let initialState = {
  title: "",
  choices: ["", ""],
}

@react.component
let make = () => {
  let (showPreview, setShowPreview) = React.useState(_ => true)
  let ({choices, title}, dispatch) = React.useReducer(reducer, initialState)
  let choiceCount = choices->Array.length

  let onTitleChange = React.useCallback0(e => {
    open SanitizeHtml
    let sanitizeConfig = {
      allowedAttributes: (),
      allowedTags: ["div"],
    }
    let sanitizedContent = SanitizeHtml.make((e->ReactEvent.Form.target)["value"], sanitizeConfig)
    ChangeTitle(sanitizedContent)->dispatch
  })
  let onChoiceChange = (e, i) => {
    // React.useCallback0(e => {
    open SanitizeHtml
    let sanitizeConfig = {
      allowedAttributes: (),
      allowedTags: ["div"],
    }
    let sanitizedContent = SanitizeHtml.make((e->ReactEvent.Form.target)["value"], sanitizeConfig)
    ChangeChoice({index: i, value: sanitizedContent})->dispatch
  }
  // )

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

  let onSubmit = e => {
    e->ReactEvent.Form.preventDefault
    ()
  }

  <div className="relative py-4 w-full h-full flex flex-col justify-around items-center">
    <EmptyVoteChart className="absolute bottom-5 w-14" choiceCount={choiceCount + 1} />
    <ReactTooltip
      className="z-50 h-fit-content max-w-xs"
      anchorSelect="#create-vote-question"
      closeOnEsc=true
      clickable=true
      content="This will provide greater detail toward the process of asking a question. We will have to explain 3 main things. \n 1. The components of a question (Title, Answers, correct answer, further details). \n 2. Asking a question requires an unused VOTE token.  \n 3. If a vote token is not owned, your question will be turned into a Discord command that you can paste into the questions channel on Discord. "
    />
    <form
      className="h-full w-full rounded-xl flex justify-between flex-col z-10 pb-4 gap-4" onSubmit>
      <div
        className=" relative flex items-center pr-1 text-wrap focus-within:bg-transparent border-y-2 focus-within:ring-0 border-default-dark focus-within:backdrop-blur-md bg-white transition-all duration-200 ease-linear">
        <ContentEditable
          editablehasplaceholder="true"
          placeholder="Ask a question..."
          html=title
          onChange={onTitleChange}
          className="w-full border-none focus:ring-0  bg-transparent cursor-pointer min-h-[8rem] pr-10 focus:cursor-text text-center focus:text-left placeholder:text-left placeholder:text-xl text-xl transition-all duration-300 ease-linear "
        />
        <div
          id="create-vote-question"
          type_="button"
          className="absolute flex right-0  items-center justify-center text-default-dark font-bold text-3xl h-10 w-10 hover:scale-125 hover:default transition-all duration-200 ease-linear rounded-full">
          <ReactIcons.LuInfo className="text-default-dark" />
        </div>
      </div>
      <ol className="mb-auto flex flex-col  ">
        {choices
        ->Array.mapWithIndex((_, index) => {
          <li
            key={Int.toString(index)}
            className="pr-10 w-full flex flex-auto items-center gap-2 focus-within:bg-transparent text-center focus-within:border-y-2 focus-within:text-left focus-within:border-default-dark focus-within:backdrop-blur-md bg-white transition-all duration-200 ease-linear">
            <div
              className=" w-9 flex items-center justify-center relative font-bold text-2xl h-full text-default-dark bg-default px-3  border-default-dark border-r-2 overflow-hidden ">
              <p className="z-10 "> {(index + 65)->String.fromCharCode->React.string} </p>
            </div>
            <ContentEditable
              editablehasplaceholder="true"
              placeholder="Option..."
              html={choices[index]->Option.getWithDefault("")}
              onChange={onChoiceChange(_, index)}
              className="w-[90%]  max-w-full border-none focus:ring-0 bg-transparent cursor-pointer h-full placeholder:text-center focus:cursor-text min-h-[3rem]"
            />
            <button
              type_="button"
              onClick={handleRemoveChoice(_, index)}
              className="absolute flex right-0  items-center justify-center text-default-dark font-bold text-3xl h-10 w-10 hover:scale-125 hover:default transition-all duration-200 ease-linear">
              <ReactIcons.LuSettings size="1.5rem" className="text-default-darker  " />
            </button>
          </li>
        })
        ->React.array}
        <div className="w-full text-center pb-8">
          <button
            className="w-4 font-bold font-fugaz text-4xl py-2 hover:scale-125 transition-all duration-300 ease-linear"
            type_="button"
            onClick={handleAddChoice}>
            {"+"->React.string}
          </button>
        </div>
      </ol>
      <button
        type_="submit"
        className=" bg-default-light rounded-xl p-4 max-w-xs self-center font-semibold hover:bg-transparent hover:border-2 border-default-dark transition-all ease-linear hover:scale-110 hover:backdrop-blur-sm ">
        {"Preview Your Vote"->React.string}
      </button>
    </form>
    // <DailyQuestionModal isOpen={showPreview}>
    //   <DailyQuestionPreview />
    // </DailyQuestionModal>
  </div>
}
