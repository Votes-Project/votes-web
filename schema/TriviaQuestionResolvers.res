open Question

@gql.field
let triviaQuestionById = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.question.triviaById->DataLoader.load(id) {
  | None => panic("Something went wrong fetching the question")
  | Some(question) => Some(question)
  }
}

@gql.field
let randomQuestion = async (_: Schema.query, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.question.random->DataLoader.load("1") {
  | [] => panic("Something went wrong fetching the question")
  | question => question[0]
  }
}

@gql.field
let randomQuestions = async (
  _: Schema.query,
  ~limit,
  ~first=?,
  ~after=?,
  ~before=?,
  ~last=?,
  ~ctx: ResGraphContext.context,
): triviaQuestionConnection => {
  let questions = await ctx.dataLoaders.question.random->DataLoader.load(limit->Int.toString)
  questions->ResGraph.Connections.connectionFromArray(~args={first, after, before, last})
}

@gql.field
let question = async (q: triviaQuestion, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.question.triviaById->DataLoader.load(q.id) {
  | None => panic("Something went wrong fetching the question")
  | Some({question: {text}}) => text
  }
}

@gql.field
let options = async (q: triviaQuestion, ~ctx: ResGraphContext.context): array<string> => {
  switch await ctx.dataLoaders.question.triviaById->DataLoader.load(q.id) {
  | None => panic("Something went wrong fetching the question")
  | Some(question) =>
    question.incorrectAnswers->Array.concat([question.correctAnswer])->Array.toShuffled
  }
}
