/**
 * @RelayResolver
 *
 * @onType Question
 * @fieldName title
 * @rootFragment QuestionTitleResolver
 *
 * The decoded title of a question from Byte to string
 */
type t = string

module Fragment = %relay(`
  fragment QuestionTitleResolver on Question {
    question
  }
`)

let default = Fragment.makeRelayResolver(({question}) => {
  Js.log2("title: ", question->QuestionUtils.parseHexTitle)
  question->QuestionUtils.parseHexTitle
})
