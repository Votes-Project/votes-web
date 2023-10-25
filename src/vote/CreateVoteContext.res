type changeTextActions =
  | ChangeOption({index: int, value: string})
  | ChangeTitle(string)

type action =
  | ...changeTextActions
  | AddOption
  | RemoveOption(int)
  | MaxOptionsReached

type state = {title: string, options: array<string>}

let reducer = (state, action) => {
  switch action {
  | AddOption => {
      ...state,
      options: state.options->Array.concat([""]),
    }
  | RemoveOption(indexToRemove) => {
      ...state,
      options: state.options->Array.filterWithIndex((_, i) => indexToRemove !== i),
    }
  | ChangeOption({index, value}) =>
    let options = state.options->Array.mapWithIndex((option, i) => {
      i === index ? value : option
    })
    {...state, options}

  | MaxOptionsReached => state
  | ChangeTitle(value) => {...state, title: value}
  }
}

let initialState = {
  title: "",
  options: ["", ""],
}

type context = {
  state: state,
  dispatch: action => unit,
}

let context = React.createContext({
  state: initialState,
  dispatch: _ => (),
})

module Provider = {
  let make = React.Context.provider(context)
}
