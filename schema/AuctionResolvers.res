open Auction

type data = {auction: auction}

/* takes a Graphclient ID and returns a single Auction Item */
@gql.field
let auction = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<auction> => {
  let id =
    id->ResGraph.Utils.Base64.decode->String.split(":")->Array.get(1)->Option.getWithDefault(id)
  switch await ctx.dataLoaders.auction.byId->DataLoader.load(id) {
  | None => panic("Did not find auction settled with that ID")
  | Some(auction) => auction->Some
  }
}

@gql.field
let auctions = async (
  _: Schema.query,
  ~orderBy: option<AuctionDataLoaders.orderBy_Auctions>,
  ~orderDirection,
  ~where,
  ~first,
  ~after,
  ~before,
  ~last,
  ~ctx: ResGraphContext.context,
): option<auctionConnection> => {
  let auctions =
    await ctx.dataLoaders.auction.list->DataLoader.load({first, orderBy, orderDirection, where})
  auctions->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})->Some
}

@gql.field
let bids = async (
  auction: auction,
  ~orderBy,
  ~orderDirection,
  ~where: option<AuctionBidDataLoaders.where_AuctionBids>,
  ~first,
  ~after,
  ~before,
  ~last,
  ~ctx: ResGraphContext.context,
): option<AuctionBid.auctionBidConnection> => {
  let where = switch where {
  | Some(where) =>
    {
      ...where,
      tokenId: auction.tokenId,
    }->Some
  | None => {tokenId: auction.tokenId}->Some
  }

  let bids = await ctx.dataLoaders.auctionBid.list->DataLoader.load({
    first,
    orderBy,
    orderDirection,
    where,
  })

  bids->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})->Some
}
