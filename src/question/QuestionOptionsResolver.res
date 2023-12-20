/**
  * @RelayResolver
  *
  * @onType Question
  * @fieldName options
  * @rootFragment QuestionOptionsResolver
  *
  * The decoded options of a question from Byte to string
  */
type t = array<QuestionUtils.questionOption>

module Fragment = %relay(`
  fragment QuestionOptionsResolver on Question {
    question
  }
`)

let default = Fragment.makeRelayResolver(({question}) =>
  question->QuestionUtils.parseHexOptions->Some
)
