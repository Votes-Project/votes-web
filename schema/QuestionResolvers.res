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
