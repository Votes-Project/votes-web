@gql.type
type questionOption = {
  /** The text of the option */
  @gql.field
  option?: string,
  /** The id of the option */
  @gql.field
  details?: string,
}

@gql.enum
type questionState =
  | Submitted
  | Approved
  | Used
  | Flagged

@gql.type
type question = {
  ...NodeInterface.node,
  question: string,
  /** The ethereum address who asked the question */
  @gql.field
  asker: string,
  /** State of the question (Submitted | Approved | Used | Flagged) */
  @gql.field
  state: questionState,
  vote: GraphClient.linkById,
  options: array<questionOption>,
  modifiedTimestamp: string,
  day: option<string>,
  contract: GraphClient.linkById,
}

@gql.type
type textQuestion = {
  @gql.field
  text: string,
}

@gql.type
type triviaQuestion = {
  ...NodeInterface.node,
  /** The question */
  question: textQuestion,
  /** The incorrect answers */
  incorrectAnswers: array<string>,
  /** The correct answer */
  correctAnswer: string,
  /** The day the question was asked */
  day: option<string>,
}

/** An edge to a question. */
@gql.type
type questionEdge = ResGraph.Connections.edge<question>

/** A connection of questions. */
@gql.type
type questionConnection = ResGraph.Connections.connection<questionEdge>

/** An edge to a trivia question. */
@gql.type
type triviaQuestionEdge = ResGraph.Connections.edge<triviaQuestion>

/** A connection of trivia questions. */
@gql.type
type triviaQuestionConnection = ResGraph.Connections.connection<triviaQuestionEdge>

let questionTextStruct = {
  open S
  object(({field}) => {
    text: "text"->field(string),
  })
}
let triviaQuestionStruct = {
  open S
  object(({field}) => {
    id: "id"->field(string),
    question: "question"->field(questionTextStruct),
    incorrectAnswers: "incorrectAnswers"->field(array(string)),
    correctAnswer: "correctAnswer"->field(string),
    day: "day"->field(option(string)),
  })
}
