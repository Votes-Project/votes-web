type textQuestion = {text: string}

@gql.type
type question = {
  ...NodeInterface.node,
  /** The question */
  question: textQuestion,
  /** The incorrect answers */
  incorrectAnswers: array<string>,
  /** The correct answer */
  correctAnswer: string,
}

/** An edge to a question. */
@gql.type
type questionEdge = ResGraph.Connections.edge<question>

/** A connection of questions. */
@gql.type
type questionConnection = ResGraph.Connections.connection<questionEdge>

let questionTextStruct = {
  open S
  object(({field}) => {
    text: "text"->field(string),
  })
}
let questionStruct = {
  open S
  object(({field}) => {
    id: "id"->field(string),
    question: "question"->field(questionTextStruct),
    incorrectAnswers: "incorrectAnswers"->field(array(string)),
    correctAnswer: "correctAnswer"->field(string),
  })
}
