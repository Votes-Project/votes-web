/** Fetches an object given its ID.*/
@gql.field
let node = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
  Interface_node.Resolver.t,
> => {
  switch id->ResGraph.idToString->String.split(":") {
  | [typenameAsString, id] =>
    switch typenameAsString->Interface_node.ImplementedBy.decode {
    | None => None
    | Some(AuctionSettled) =>
      switch await ctx.dataLoaders.auctionSettled.byId->DataLoader.load(id) {
      | None => panic("Did not find auction settled with that ID")
      | Some(auctionSettled) => AuctionSettled(auctionSettled)->Some
      }
    | Some(QuestionSubmitted) =>
      switch await ctx.dataLoaders.questionSubmitted.byId->DataLoader.load(id) {
      | None => panic("Did not find question submitted with that ID")
      | Some(questionSubmitted) => QuestionSubmitted(questionSubmitted)->Some
      }
    | Some(AuctionCreated) =>
      switch await ctx.dataLoaders.auctionCreated.byId->DataLoader.load(id) {
      | None => panic("Did not find auction created with that ID")
      | Some(auctionCreated) => AuctionCreated(auctionCreated)->Some
      }
    }
  | _ => None
  }
}

/** Fetches objects given their IDs. */
@gql.field
let nodes = (query: Schema.query, ~ids, ~ctx: ResGraphContext.context) => {
  ids->Array.map(id => node(query, ~id, ~ctx))
}

@gql.field
let id = (node: NodeInterface.node, ~typename: Interface_node.ImplementedBy.t) => {
  `${typename->Interface_node.ImplementedBy.toString}:${node.id}`
  ->ResGraph.Utils.Base64.encode
  ->ResGraph.id
}
