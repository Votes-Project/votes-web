type changeTextActions =
  | ChangeOption({index: int, value: string})
  | ChangeTitle(string)
  | ChangeOptionDetail({index: int, value: string})

type action =
  | ...changeTextActions
  | AddOption
  | RemoveOption(int)
  | MaxOptionsReached

type state = {question: QuestionUtils.question}

let reducer = (state, action) => {
  switch action {
  | AddOption => {
      question: {
        ...state.question,
        options: state.question.options->Array.concat([{}]),
      },
    }
  | RemoveOption(indexToRemove) => {
      question: {
        ...state.question,
        options: state.question.options->Array.filterWithIndex((_, i) => indexToRemove !== i),
      },
    }
  | ChangeOption({index, value}) =>
    let options = state.question.options->Array.mapWithIndex((option, i) => {
      if i === index {
        switch value {
        | "" => {...option, option: ?None}
        | _ => {...option, option: ?Some(value)}
        }
      } else {
        option
      }
    })
    {question: {...state.question, options}}
  | ChangeOptionDetail({index, value}) =>
    let options = state.question.options->Array.mapWithIndex((option, i) => {
      if i === index {
        switch value {
        | "" => {...option, details: ?None}
        | _ => {...option, details: ?Some(value)}
        }
      } else {
        option
      }
    })
    {question: {...state.question, options}}

  | MaxOptionsReached => state
  | ChangeTitle(value) =>
    switch value {
    | "" => {question: {...state.question, title: None}}

    | _ => {question: {...state.question, title: Some(value)}}
    }
  }
}

let initialState = {
  question: QuestionUtils.emptyQuestion,
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
