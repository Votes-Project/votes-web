module Fragment = %relay(`
    fragment OptionsList_question on Question {
      options
    }
  `)

@react.component
let make = (~question, ~answer=?) => {
  let options = Fragment.use(question).options->Option.getWithDefault([])

  options
  ->Array.mapWithIndex(({?option}, index) =>
    switch answer {
    | Some(answer) =>
      <AnswerItem key={index->Int.toString} option={Option.getExn(option)} answer index />
    | _ => <OptionItem key={index->Int.toString} option={Option.getExn(option)} index />
    }
  )
  ->React.array
}
