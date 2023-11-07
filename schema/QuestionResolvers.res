open Question
@gql.field
let questionById = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.question.byId->DataLoader.load(id) {
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
): questionConnection => {
  let questions = await ctx.dataLoaders.question.random->DataLoader.load(limit->Int.toString)
  questions->ResGraph.Connections.connectionFromArray(~args={first, after, before, last})
}

@gql.field
let question = async (q: question, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.question.byId->DataLoader.load(q.id) {
  | None => panic("Something went wrong fetching the question")
  | Some({question: {text}}) => text
  }
}
@gql.field
let options = async (question: question, ~ctx: ResGraphContext.context): array<string> => {
  switch await ctx.dataLoaders.question.byId->DataLoader.load(question.id) {
  | None => panic("Something went wrong fetching the question")
  | Some(question) =>
    question.incorrectAnswers->Array.concat([question.correctAnswer])->Array.toShuffled
  }
}
