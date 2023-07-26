open AuctionCreated

module Node = {
  type data = {auctionCreated: auctionCreated}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionCreatedDocument"

  @gql.field
  let auctionCreated = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
    auctionCreated,
  > => {
    switch await ctx.dataLoaders.auctionCreated.byId->DataLoader.load(id) {
    | None => panic("Did not find auction settled with that ID")
    | Some(auctionCreated) => auctionCreated->Some
    }
  }
}

module Connection = {
  type data = {auctionCreateds: array<auctionCreated>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionCreatedsDocument"

  @gql.enum
  type orderBy_AuctionCreateds = | @as("id") ID | @as("tokenId") TokenId

  @gql.field
  let auctionCreateds = async (
    _: Schema.query,
    ~skip,
    ~orderBy,
    ~orderDirection,
    ~first,
    ~after,
    ~before,
    ~last,
  ): option<auctionCreatedConnection> => {
    open GraphClient

    let res = await executeWithList(
      document,
      {
        first: first->Option.getWithDefault(100),
        skip: skip->Option.getWithDefault(0),
        orderBy: orderBy->Option.getWithDefault(ID),
        orderDirection: orderDirection->Option.getWithDefault(Asc),
      }, //Probably shouldn't have to write defaults here
    )

    res.data->Option.map(data =>
      data.auctionCreateds
      ->Array.map(auctionCreated => (auctionCreated :> AuctionCreated.auctionCreated))
      ->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
    )
  }
}