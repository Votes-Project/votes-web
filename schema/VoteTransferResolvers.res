open VoteTransfer
module Node = {
  type data = {transfer: voteTransfer}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetVoteTransferDocument"

  @gql.field
  let voteTransfer = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
    voteTransfer,
  > => {
    let id =
      id->ResGraph.Utils.Base64.decode->String.split(":")->Array.get(1)->Option.getWithDefault(id)
    switch await ctx.dataLoaders.voteTransfer.byId->DataLoader.load(id) {
    | None => panic("Did not find auction settled with that ID")
    | Some(transfer) => transfer->Some
    }
  }
}

module Connection = {
  type data = {transfers: array<voteTransfer>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetVoteTransfersDocument"

  @gql.enum
  type orderBy_Transfers =
    | @as("id") ID
    | @as("tokenId") TokenId
    | @as("winner") Winner
    | @as("blockNumber") BlockNumber

  @gql.inputObject
  type where_Transfers = {
    id?: string,
    tokenId?: string,
    from?: string,
  }

  @gql.field
  let voteTransfers = async (
    _: Schema.query,
    ~skip,
    ~orderBy,
    ~orderDirection,
    ~where,
    ~first,
    ~after,
    ~before,
    ~last,
  ): option<voteTransferConnection> => {
    open GraphClient

    let res = await executeWithList(
      document,
      {
        first: first->Option.getWithDefault(10),
        skip: skip->Option.getWithDefault(0),
        orderBy: orderBy->Option.getWithDefault(ID),
        orderDirection: orderDirection->Option.getWithDefault(Asc),
        where: where->Option.getWithDefault(({}: where_Transfers)),
      }, //Probably shouldn't have to write defaults here
    )

    res.data->Option.map(data =>
      data.transfers
      ->Array.map(transfer => (transfer :> VoteTransfer.voteTransfer))
      ->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
    )
  }
}
