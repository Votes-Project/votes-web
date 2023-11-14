type changeTextActions =
  | ChangeOption({index: int, value: string})
  | ChangeTitle(string)
  | ChangeOptionDetail({index: int, value: string})

type action =
  | ...changeTextActions
  | AddOption
  | RemoveOption(int)
  | MaxOptionsReached

type state = {title: option<string>, options: array<option<string>>}

let reducer = (state, action) => {
  switch action {
  | AddOption => {
      ...state,
      options: state.options->Array.concat([None]),
    }
  | RemoveOption(indexToRemove) => {
      ...state,
      options: state.options->Array.filterWithIndex((_, i) => indexToRemove !== i),
    }
  | ChangeOption({index, value}) =>
    let options = state.options->Array.mapWithIndex((option, i) => {
      switch (value, index) {
      | ("", _) => None
      | (_, _) if i === index => Some(value)
      | _ => option
      }
    })
    {...state, options}
  | ChangeOptionDetail(value) => state

  | MaxOptionsReached => state
  | ChangeTitle(value) =>
    switch value {
    | "" => {...state, title: None}
    | _ => {...state, title: Some(value)}
    }
  }
}

let initialState = {
  title: None,
  options: [None, None],
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
