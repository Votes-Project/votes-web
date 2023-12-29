module QuestionFragment = %relay(`
fragment OptionsList_question on Question {
  options
}
`)

@react.component
let make = (~question) => {
  let options = QuestionFragment.use(question).options->Option.getWithDefault([])

  options
  ->Array.mapWithIndex(({?option}, index) =>
    <ErrorBoundary
      fallback={_ =>
        <li key={index->Int.toString}> {"Error: Failed to parse option value"->React.string} </li>}>
      <OptionItem key={index->Int.toString} option index />
    </ErrorBoundary>
  )
  ->React.array
}
