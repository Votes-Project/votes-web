module VoteOptionInput = {
  @react.component
  let make = (~index, ~isOpen) => {
    let {state: {options}, dispatch} = React.useContext(CreateVoteContext.context)

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

    <div
      id={`create-vote-option-${Int.toString(index)}`}
      onFocus=handleFocus
      className="flex items-center pl-4 w-[90%] max-w-full break-all border-none focus:ring-0 bg-transparent cursor-pointer h-full placeholder:text-center focus:cursor-text min-h-[3.5rem]">
      {isOpen
        ? <div className="h-40 w-full flex flex-col justify-around">
            <ContentEditable
              editablehasplaceholder="true"
              placeholder="Option..."
              html={options[index]
              ->Option.flatMap(o => o)
              ->Option.getWithDefault("")}
              onChange={onOptionChange(_, index)}
              className=" text-default lg:text-primary-dark focus:text-default-darker "
            />
            <div className="flex gap-2 pl-5 w-full">
              <p className="flex items-center font-semibold">
                {"Details"->React.string}
                <ReactIcons.LuArrowRight />
              </p>
              <ContentEditable
                editablehasplaceholder="true"
                placeholder="Details..."
                html={""}
                onChange={onDetailChange(_, index)}
                className=" text-default lg:text-primary-dark focus:text-default-darker border-b focus:border-black flex-1"
              />
            </div>
            <div className="flex justify-between items-center">
              <button
                type_="button"
                onClick={_ => ()}
                className="text-lg flex gap-2 items-center font-bold text-default-dark lg:text-active hover:scale-105 hover:lg:scale-105 transition-all duration-200 ease-linear">
                <ReactIcons.LuPlus />
                {"Add Details"->React.string}
              </button>
              <button
                type_="button"
                disabled={Array.length(options) <= 2}
                onClick={_ => RemoveOption(index)->dispatch}
                className="text-lg flex gap-2 items-center font-bold text-red-500 disabled:text-default disabled:lg:text-primary hover:scale-105transition-all duration-200 ease-linear">
                <ReactIcons.LuTrash />
                {"Delete"->React.string}
              </button>
            </div>
          </div>
        : <ContentEditable
            editablehasplaceholder="true"
            placeholder="Option..."
            html={options[index]
            ->Option.flatMap(o => o)
            ->Option.getWithDefault("")}
            onChange={onOptionChange(_, index)}
            className=""
          />}
    </div>
  }
}

@react.component
let make = () => {
  let {state} = React.useContext(CreateVoteContext.context)

  let (toggleSettingsIndex, setToggleSettingsIndex) = React.useState(() => None)
  let handleSettingsClick = (_, index) =>
    switch toggleSettingsIndex {
    | Some(i) if i == index => setToggleSettingsIndex(_ => None)
    | _ => setToggleSettingsIndex(_ => Some(index))
    }

  <ol className="flex flex-col justify-start items-start flex-1 ">
    {state.options
    ->Array.mapWithIndex((_, index) => {
      <li
        key={Int.toString(index)}
        className="relative pr-10 my-3 w-full flex items-center border-2 text-left lg:border-primary border-default backdrop-blur-md transition-all duration-200 ease-linear rounded-xl">
        <div
          className="w-9 flex items-center justify-center relative font-bold text-2xl h-full text-default-dark lg:text-primary-dark bg-default lg:bg-primary px-3 rounded-l-lg border-default-dark lg:border-primary border-r-2 overflow-hidden ">
          <p className="z-10 "> {(index + 65)->String.fromCharCode->React.string} </p>
        </div>
        <VoteOptionInput index isOpen={toggleSettingsIndex == Some(index)} />
        <button
          type_="button"
          onClick={handleSettingsClick(_, index)}
          className="absolute flex right-0 top-2 items-center font-bold text-2xl h-10 w-10 hover:scale-125 hover:default transition-all duration-200 ease-linear text-default-darker">
          {toggleSettingsIndex == Some(index)
            ? <ReactIcons.LuArrowLeft />
            : <ReactIcons.LuSettings />}
        </button>
      </li>
    })
    ->React.array}
  </ol>
}
