open Vote

@gql.field
let vote = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<vote> => {
  let id =
    id->ResGraph.Utils.Base64.decode->String.split(":")->Array.get(1)->Option.getWithDefault(id)
  switch await ctx.dataLoaders.vote.byId->DataLoader.load(id) {
  | None => panic("Did not find auction settled with that ID")
  | Some(vote) => vote->Some
  }
}

@gql.field
let votes = async (
  _: Schema.query,
  ~skip,
  ~orderBy,
  ~orderDirection,
  ~where,
  ~first,
  ~after,
  ~before,
  ~last,
  ~ctx: ResGraphContext.context,
): option<voteConnection> => {
  let votes =
    await ctx.dataLoaders.vote.list->DataLoader.load({first, skip, orderBy, orderDirection, where})
  votes->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})->Some
}

module VoteContract = {
  open VoteContract
  type data = {voteContract: voteContract}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetVoteDocument"

  @gql.field
  let voteContract = async (_: vote, ~id, ~ctx: ResGraphContext.context): option<voteContract> => {
    switch await ctx.dataLoaders.voteContract.byId->DataLoader.load(id) {
    | None => panic("Did not find auction settled with that ID")
    | Some(voteContract) => voteContract->Some
    }
  }
}
