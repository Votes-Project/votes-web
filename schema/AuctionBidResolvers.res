open AuctionBid

module Node = {
  type data = {auctionBid: auctionBid}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionBidDocument"

  /* takes a Graphclient ID and returns a single AuctionBid Item */
  @gql.field
  let auctionBid = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
    auctionBid,
  > => {
    switch await ctx.dataLoaders.auctionBid.byId->DataLoader.load(id) {
    | None => panic("Did not find auction settled with that ID")
    | Some(auctionBid) => auctionBid->Some
    }
  }
}

module Connection = {
  type data = {auctionBids: array<auctionBid>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionBidsDocument"

  @gql.enum
  type orderBy_AuctionBids =
    | @as("id") ID
    | @as("tokenId") TokenId
    | @as("blockTimestamp") BlockTimestamp
    | @as("amount") Amount

  @gql.inputObject
  type where_AuctionBids = {
    id?: string,
    tokenId?: string,
  }

  @gql.field
  let auctionBids = async (
    _: Schema.query,
    ~orderBy,
    ~orderDirection,
    ~where,
    ~first,
    ~after,
    ~before,
    ~last,
  ): option<auctionBidConnection> => {
    open GraphClient

    let res = await executeWithList(
      document,
      {
        first: first->Option.getWithDefault(100),
        orderBy: orderBy->Option.getWithDefault(ID),
        orderDirection: orderDirection->Option.getWithDefault(Asc),
        where: where->Option.getWithDefault(({}: where_AuctionBids)),
      },
    )

    res.data->Option.map(data => {
      data.auctionBids
      ->Array.map(auctionBid => (auctionBid :> AuctionBid.auctionBid))
      ->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
    })
  }
}
