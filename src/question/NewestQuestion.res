module QuestionFragment = %relay(`
  fragment NewestQuestion_question on Question {
    id
    day
    ...SingleQuestion_OptionsPage
    ...QuestionTitle_question
    ...QuestionAnswer_question
  }
`)
module AnswerFragment = %relay(`
  fragment NewestQuestion_answer on Answer {
    ...QuestionAnswer_answer
  }
`)
@react.component
let make = (~question, ~answer) => {
  let question = QuestionFragment.use(question)
  let answer = AnswerFragment.useOpt(answer)

  let isWithinDay = switch question.day {
  | Some(day) =>
    Date.now() <
    Helpers.Date.secondsToMilliseconds(day->BigInt.toFloat) +. Helpers.Date.dayInMilliseconds
  | _ => false
  }

  switch question {
  | question if Option.isSome(answer) =>
    <QuestionAnswer
      question={question.fragmentRefs} answer={answer->Option.map(a => a.fragmentRefs)}
    />
  | question if isWithinDay => <SingleQuestion.OptionsPage question={question.fragmentRefs} />
  | _ =>
    <QuestionAnswer
      question={question.fragmentRefs} answer={answer->Option.map(a => a.fragmentRefs)}
    />
  }
}
