open Question

@gql.field
let question = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.question.byId->DataLoader.load(id) {
  | None => panic("Something went wrong fetching the question")
  | Some(question) => Some(question)
  }
}

@gql.field
let questions = async (
  _: Schema.query,
  ~orderBy: option<QuestionDataLoaders.orderBy_Questions>,
  ~orderDirection,
  ~where,
  ~first,
  ~after,
  ~before,
  ~last,
  ~ctx: ResGraphContext.context,
): questionConnection => {
  let questions =
    await ctx.dataLoaders.question.list->DataLoader.load({first, orderBy, orderDirection, where})
  questions->ResGraph.Connections.connectionFromArray(~args={first, after, before, last})
}

/** The question */
@gql.field
let title = async (q: question, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.question.byId->DataLoader.load(q.id) {
  | None => panic("Something went wrong fetching the question")
  | Some({question}) => question
  }
}

@gql.field
let options = async (q: question, ~ctx: ResGraphContext.context): array<questionOption> => {
  switch await ctx.dataLoaders.question.byId->DataLoader.load(q.id) {
  | None => panic("Something went wrong fetching the question")
  | Some({options}) => options
  }
}

/* The token ID of the vote token */
@gql.field
let tokenId = (question: question): Schema.BigInt.t => question.tokenId->BigInt.fromString

// @gql.field
// let contract = async (
//   question: question,
//   ~ctx: ResGraphContext.context,
// ): QuestionContract.questionContract => {
//   switch await ctx.dataLoaders.questionContract.byId->DataLoader.load(vote.contract.id) {
//   | None => panic("Did not find question contract")
//   | Some(questionContract) =>
//     ctx.dataLoaders.questionContract.byId->DataLoader.prime(Some(questionContract))
//     questionContract
//   }
// }
