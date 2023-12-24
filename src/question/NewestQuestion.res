module QuestionFragment = %relay(`
  fragment NewestQuestion_node on Question {
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

  switch (answer, question) {
  | (Some({fragmentRefs}), {fragmentRefs: questionFragmentRefs}) =>
    <QuestionAnswer question={questionFragmentRefs} answer={fragmentRefs} />
  | (None, {fragmentRefs}) => <SingleQuestion.OptionsPage question={fragmentRefs} />
  }
}
