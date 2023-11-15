type questionOption = {
  option?: string,
  details?: string,
  numAnswers?: BigInt.t,
}

type changeTextActions =
  | ChangeOption({index: int, value: string})
  | ChangeTitle(string)
  | ChangeOptionDetail({index: int, value: string})

type action =
  | ...changeTextActions
  | AddOption
  | RemoveOption(int)
  | MaxOptionsReached

type state = {title: option<string>, options: array<questionOption>}

let reducer = (state, action) => {
  switch action {
  | AddOption => {
      ...state,
      options: state.options->Array.concat([{}]),
    }
  | RemoveOption(indexToRemove) => {
      ...state,
      options: state.options->Array.filterWithIndex((_, i) => indexToRemove !== i),
    }
  | ChangeOption({index, value}) =>
    let options = state.options->Array.mapWithIndex((option, i) => {
      if i === index {
        switch value {
        | "" => {...option, option: ?None}
        | _ => {...option, option: ?Some(value)}
        }
      } else {
        option
      }
    })
    {...state, options}
  | ChangeOptionDetail({index, value}) =>
    let options = state.options->Array.mapWithIndex((option, i) => {
      if i === index {
        switch value {
        | "" => {...option, details: ?None}
        | _ => {...option, details: ?Some(value)}
        }
      } else {
        option
      }
    })
    {...state, options}

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
  options: [{}, {}],
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
