open QuestionSubmitted
module Node = {
  type data = {questionSubmitted: questionSubmitted}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetQuestionSubmittedDocument"

  @gql.field
  let questionSubmitted = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
    questionSubmitted,
  > => {
    switch await ctx.dataLoaders.questionSubmitted.byId->DataLoader.load(id) {
    | None => panic("Did not find auction settled with that ID")
    | Some(questionSubmitted) => questionSubmitted->Some
    }
  }
}

module Connection = {
  type data = {questionSubmitteds: array<questionSubmitted>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> =
    "GetQuestionSubmittedsDocument"

  @gql.field
  let questionSubmitteds = async (_: Schema.query, ~skip, ~first, ~after, ~before, ~last): option<
    questionSubmittedConnection,
  > => {
    open GraphClient

    let res = await executeWithList(
      document,
      {first: first->Option.getWithDefault(10), skip: skip->Option.getWithDefault(0)}, //Probably shouldn't have to write defaults here
    )

    res.data->Option.map(data =>
      data.questionSubmitteds
      ->Array.map(questionSubmitted => (questionSubmitted :> QuestionSubmitted.questionSubmitted))
      ->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
    )
  }
}
