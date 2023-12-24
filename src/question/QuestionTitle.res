module Fragment = %relay(`
    fragment QuestionTitle_question on Question {
      title
    }
  `)

let size = titleLength => {
  if titleLength <= 50 {
    "text-4xl"
  } else if titleLength <= 150 {
    "text-2xl"
  } else {
    "text-xl"
  }
}

@react.component
let make = (~question, ~className="") => {
  let question = Fragment.use(question)
  let title = question.title->Option.getWithDefault("")

  <FramerMotion.Div layout=Position layoutId="daily-question-title" className>
    {title->React.string}
  </FramerMotion.Div>
}
