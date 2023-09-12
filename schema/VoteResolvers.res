open Vote
module Node = {
  type data = {vote: vote}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetVoteDocument"

  @gql.field
  let vote = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<vote> => {
    switch await ctx.dataLoaders.vote.byId->DataLoader.load(id) {
    | None => panic("Did not find auction settled with that ID")
    | Some(vote) => vote->Some
    }
  }
}

module Connection = {
  type data = {votes: array<vote>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetVotesDocument"

  @gql.enum
  type orderBy_Votes =
    | @as("id") ID
    | @as("owner") Owner

  @gql.inputObject
  type where_Votes = {
    id?: string,
    owner?: string,
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
  ): option<voteConnection> => {
    open GraphClient

    let res = await executeWithList(
      document,
      {
        first: first->Option.getWithDefault(10),
        skip: skip->Option.getWithDefault(0),
        orderBy: orderBy->Option.getWithDefault(ID),
        orderDirection: orderDirection->Option.getWithDefault(Asc),
        where: where->Option.getWithDefault(({}: where_Votes)),
      }, //Probably shouldn't have to write defaults here
    )

    res.data->Option.map(data =>
      data.votes
      ->Array.map(vote => (vote :> Vote.vote))
      ->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
    )
  }
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
