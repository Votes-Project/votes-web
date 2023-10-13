type action =
  | AddChoice
  | RemoveChoice(int)
  | ChangeChoice({index: int, value: string})
  | MaxChoicesReached
  | ChangeTitle(string)

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
  let ({choices}, dispatch) = React.useReducer(reducer, initialState)
  let choiceCount = choices->Array.length

  let allowRemove = choiceCount > 2

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

  <div className="relative  w-full h-full flex flex-col justify-around items-center">
    <EmptyVoteChart className="" choiceCount={choiceCount + 1} />
    <div
      className="font-semibold text-default-darker [text-wrap:balance] p-2 pt-14 text-center text-sm backdrop-blur-[2px] self-stretch">
      {"This section is reserved to provide greater detail toward the process of asking a question. We will have to explain 3 main things. \n 1. The components of a question (Title, Answers, correct answer, further details). \n 2. Asking a question requires an unused VOTE token.  \n 3. If a vote token is not owned, your question will be turned into a Discord command that you can paste into the questions channel on Discord. "->React.string}
    </div>
    <form className="h-full w-full rounded-xl flex justify-around flex-col z-10 " onSubmit>
      <div className="flex flex-col justify-between rounded-2xl min-h-[600px] ">
        <textarea
          className="w-full resize-none focus:ring-default-dark border-none cursor-pointer bg-white hover:bg-transparent focus:bg-transparent focus:border-y-2 focus:border-default-dark text-center focus:text-left focus:backdrop-blur-[2px]  hover:backdrop-blur-[2px]  transition-all duration-300 ease-linear"
          type_="text"
          placeholder="Ask A Question"
          onInput={e => ChangeTitle((e->ReactEvent.Form.target)["value"])->dispatch}
        />
        <ol className="flex flex-col align-end gap-4 flex-[.9_1_0]">
          {choices
          ->Array.mapWithIndex((_, index) => {
            <li
              key={Int.toString(index)}
              className="last:border-b-0 flex items-center gap-2 px-2 text-wrap focus-within:bg-transparent focus-within:border-y-2 focus-within:border-default-dark focus-within:backdrop-blur-[2px] bg-white hover:bg-transparent hover:backdrop-blur-[2px]  transition-all duration-300 ease-linear">
              <div
                className=" flex items-center justify-center relative font-bold text-2xl h-full text-default-dark bg-default px-4 border-default-dark border-x-2 overflow-hidden ">
                <p className="z-10 "> {(index + 65)->String.fromCharCode->React.string} </p>
              </div>
              <textarea
                className="w-full border-none focus:ring-0 resize-none bg-transparent cursor-pointer py-4 text-center focus:text-left"
                type_="text"
                placeholder={"Give an answer... "}
                onInput={e =>
                  ChangeChoice({index, value: (e->ReactEvent.Form.target)["value"]})->dispatch}
              />
              <button
                type_="button"
                onClick={handleRemoveChoice(_, index)}
                className="font-bold text-2xl text-default-darker h-full hover:scale-125 transition-all duration-300 ease-linear">
                <ReactIcons.LuSettings size="1.5rem" className="text-default-darker  " />
              </button>
            </li>
          })
          ->React.array}
          <div className="w-full text-center">
            <button
              className=" w-4 font-bold font-fugaz text-4xl py-2 hover:scale-125 transition-all duration-300 ease-linear"
              type_="button"
              onClick={handleAddChoice}>
              {"+"->React.string}
            </button>
          </div>
        </ol>
      </div>
      <button
        type_="submit" className="bg-default rounded-xl p-4 max-w-xs self-center font-semibold">
        {"Preview Your Vote"->React.string}
      </button>
    </form>
  </div>
}
