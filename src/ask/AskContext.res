type questionOption = {
  option?: string,
  details?: string,
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

let decodeQuestionOption = json =>
  switch json->JSON.Decode.object {
  | Some(questionOptionDict) =>
    switch (questionOptionDict->Dict.get("option"), questionOptionDict->Dict.get("details")) {
    | (Some(option), Some(details)) => {
        option: ?option->JSON.Decode.string,
        details: ?details->JSON.Decode.string,
      }
    | (Some(option), None) => {
        option: ?option->JSON.Decode.string,
        details: ?None,
      }
    | _ => {}
    }
  | _ => {}
  }

let decodeOptions = json =>
  switch json->JSON.Decode.array {
  | Some(options) => options->Array.map(decodeQuestionOption)
  | _ => []
  }

let decodeState = json =>
  switch json->JSON.Decode.object {
  | Some(stateDict) =>
    switch (stateDict->Dict.get("title"), stateDict->Dict.get("options")) {
    | (Some(String(title)), Some(options)) =>
      Some({
        title: Some(title),
        options: options->decodeOptions,
      })
    | _ => None
    }
  | _ => None
  }

let parseHexState = (hex): state => {
  hex->Option.mapWithDefault(initialState, hex => {
    try {
      switch hex->Viem.hexToString->JSON.parseExn->decodeState {
      | Some(state) => state
      | None => initialState
      }
    } catch {
    | _ => initialState
    }
  })
}
