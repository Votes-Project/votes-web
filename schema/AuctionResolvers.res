open Auction

module BidsConnection = {
  type data = {auctionBids: array<AuctionBid.auctionBid>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionBidsDocument"
  @gql.field
  let bids = async (
    auction: auction,
    ~orderBy,
    ~orderDirection,
    ~where,
    ~first,
    ~after,
    ~before,
    ~last,
  ): option<AuctionBid.auctionBidConnection> => {
    open GraphClient

    let res = await executeWithList(
      document,
      {
        first: first->Option.getWithDefault(1000),
        orderBy: orderBy->Option.getWithDefault(AuctionBidResolvers.Connection.BlockTimestamp),
        orderDirection: orderDirection->Option.getWithDefault(Desc),
        where: where->Option.getWithDefault(
          ({tokenId: auction.tokenId}: AuctionBidResolvers.Connection.where_AuctionBids),
        ),
      },
    )

    res.data->Option.map(({auctionBids}) => {
      auctionBids
      ->Array.map(bid => (bid :> AuctionBid.auctionBid))
      ->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
    })
  }
}

module Node = {
  type data = {auction: auction}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionDocument"

  /* takes a Graphclient ID and returns a single Auction Item */
  @gql.field
  let auction = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<auction> => {
    switch await ctx.dataLoaders.auction.byId->DataLoader.load(id) {
    | None => panic("Did not find auction settled with that ID")
    | Some(auction) => auction->Some
    }
  }
}

module Connection = {
  type data = {auctions: array<auction>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionsDocument"

  @gql.enum
  type orderBy_Auctions =
    | @as("id") ID
    | @as("tokenId") TokenId
    | @as("blockTimestamp") BlockTimestamp
    | @as("amount") Amount

  @gql.inputObject
  type where_Auctions = {
    id?: string,
    tokenId?: string,
  }

  @gql.field
  let auctions = async (
    _: Schema.query,
    ~orderBy,
    ~orderDirection,
    ~where,
    ~first,
    ~after,
    ~before,
    ~last,
  ): option<auctionConnection> => {
    open GraphClient

    let res = await executeWithList(
      document,
      {
        first: first->Option.getWithDefault(100),
        orderBy: orderBy->Option.getWithDefault(ID),
        orderDirection: orderDirection->Option.getWithDefault(Asc),
        where: where->Option.getWithDefault(({}: where_Auctions)),
      },
    )

    res.data->Option.map(data => {
      data.auctions
      ->Array.map(auction => (auction :> Auction.auction))
      ->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
    })
  }
}
