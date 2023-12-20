module AskOptionInput = {
  @react.component
  let make = (~index, ~option: QuestionUtils.questionOption, ~isOpen) => {
    let {state: {question: {options}}, dispatch} = React.useContext(AskContext.context)
    let (toggleDetails, setToggleDetails) = React.useState(() => false)

    let onOptionChange = (e, i) => {
      open SanitizeHtml
      let sanitizeConfig = {
        allowedTags: ["b", "i", "em", "strong", "a", "p", "h1"],
        allowedAttributes: {"a": ["href"]},
      }
      let sanitizedContent = SanitizeHtml.make((e->ReactEvent.Form.target)["value"], sanitizeConfig)

      ChangeOption({index: i, value: sanitizedContent})->dispatch
    }

    let onDetailChange = (e, i) => {
      open SanitizeHtml
      let sanitizeConfig = {
        allowedTags: ["b", "i", "em", "strong", "a", "p", "h1"],
        allowedAttributes: {"a": ["href"]},
      }
      let sanitizedContent = SanitizeHtml.make((e->ReactEvent.Form.target)["value"], sanitizeConfig)

      ChangeOptionDetail({index: i, value: sanitizedContent})->dispatch
    }

    let handleFocus = _ => {
      document
      ->Document.getElementById(`create-vote-option-${Int.toString(index)}`)
      ->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: Center})
    }

    let handleToggleDetails = _ => {
      if toggleDetails == true {
        ChangeOptionDetail({index, value: ""})->dispatch
      }

      setToggleDetails(_ => !toggleDetails)
    }

    let handleRemoveOption = _ => {
      setToggleDetails(_ => false)
      RemoveOption(index)->dispatch
    }

    <div
      id={`create-vote-option-${Int.toString(index)}`}
      onFocus=handleFocus
      className="flex items-center pl-4 w-[90%] max-w-full break-all border-none focus:ring-0 bg-transparent cursor-pointer h-full placeholder:text-center focus:cursor-text min-h-[3.5rem]">
      {isOpen
        ? <div className="w-full flex flex-col ">
            <ContentEditable
              editablehasplaceholder="true"
              placeholder="Option..."
              html={option.option->Option.getWithDefault("")}
              onChange={onOptionChange(_, index)}
              className=" text-default lg:text-primary-dark focus:text-default-darker py-2 "
            />
            {toggleDetails
              ? <div className="flex gap-2 pl-5 w-full">
                  <p className="flex items-center font-semibold">
                    <ReactIcons.LuArrowRight />
                  </p>
                  <ContentEditable
                    editablehasplaceholder="true"
                    placeholder="Details..."
                    html={option.details->Option.getWithDefault("")}
                    onChange={onDetailChange(_, index)}
                    className="text-default-darker border-b lg:border-b-primary-dark focus:border-black flex-1"
                  />
                </div>
              : React.null}
            <div className="flex justify-between items-center py-2">
              <button
                type_="button"
                onClick={handleToggleDetails}
                className="text-md flex gap-2 items-center font-semibold text-default-dark lg:text-active hover:scale-105 hover:lg:scale-105 transition-all duration-200 ease-linear">
                {toggleDetails
                  ? <>
                      <ReactIcons.LuMinus />
                      {"Remove Details"->React.string}
                    </>
                  : <>
                      <ReactIcons.LuPlus />
                      {"Add Details"->React.string}
                    </>}
              </button>
              <button
                type_="button"
                disabled={Array.length(options) <= 2}
                onClick={handleRemoveOption}
                className="text-md flex gap-2 items-center font-semibold text-red-500 disabled:text-default disabled:lg:text-primary hover:scale-105transition-all duration-200 ease-linear">
                <ReactIcons.LuTrash />
                {"Delete"->React.string}
              </button>
            </div>
          </div>
        : <div className="flex flex-col">
            <ContentEditable
              editablehasplaceholder="true"
              placeholder="Option..."
              html={option.option->Option.getWithDefault("")}
              onChange={onOptionChange(_, index)}
              className="py-1"
            />
            {switch option.details {
            | Some(details) =>
              <p className="pl-4 text-default lg:text-primary-dark "> {details->React.string} </p>
            | None => React.null
            }}
          </div>}
    </div>
  }
}

@react.component
let make = () => {
  let {state} = React.useContext(AskContext.context)

  let (toggleSettingsIndex, setToggleSettingsIndex) = React.useState(() => None)
  let handleSettingsClick = (_, index) =>
    switch toggleSettingsIndex {
    | Some(i) if i == index => setToggleSettingsIndex(_ => None)
    | _ => setToggleSettingsIndex(_ => Some(index))
    }

  <ol className="flex flex-col justify-start items-start flex-1 ">
    {state.question.options
    ->Array.mapWithIndex((option, index) => {
      <li
        key={Int.toString(index)}
        className="relative pr-10 my-3 w-full flex items-center border-2 text-left lg:border-primary border-default backdrop-blur-md transition-all duration-200 ease-linear rounded-xl">
        <div
          className="w-9 flex items-center justify-center relative font-bold text-2xl h-full text-default-dark lg:text-primary-dark bg-default lg:bg-primary px-3 rounded-l-lg border-default-dark lg:border-primary border-r-2 overflow-hidden ">
          <p className="z-10 "> {(index + 65)->String.fromCharCode->React.string} </p>
        </div>
        <AskOptionInput index option isOpen={toggleSettingsIndex == Some(index)} />
        <button
          type_="button"
          onClick={handleSettingsClick(_, index)}
          className="absolute flex right-0 top-2 items-center font-bold text-2xl h-10 w-10 hover:default transition-all duration-200 ease-linear text-default-darker">
          {toggleSettingsIndex == Some(index)
            ? <ReactIcons.LuChevronUp size="1.5rem" />
            : <ReactIcons.LuChevronDown />}
        </button>
      </li>
    })
    ->React.array}
  </ol>
}
