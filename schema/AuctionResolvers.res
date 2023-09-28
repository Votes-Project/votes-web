open Auction

type data = {auction: auction}

/* takes a Graphclient ID and returns a single Auction Item */
@gql.field
let auction = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<auction> => {
  open ResGraph.Utils
  let id = id->Base64.decode->String.split(":")->Array.get(1)->Option.getWithDefault(id)
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
  auctions->Array.forEach(({id}) => Console.log(id))
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
): AuctionBid.auctionBidConnection => {
  let tokenId = switch auction.id->String.replace("0x", "")->Helpers.i32toInt {
  | None => panic("Could not parse auction ID")
  | Some(tokenId) => tokenId->Int.toString
  }

  let where = switch where {
  | Some(where) =>
    {
      ...where,
      tokenId,
    }->Some
  | None => {tokenId: tokenId}->Some
  }

  let bids = await ctx.dataLoaders.auctionBid.list->DataLoader.load({
    first,
    orderBy,
    orderDirection,
    where,
  })
  Js.log2("bids: ", bids)

  bids->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
}

@gql.field
let vote = async (auction: auction, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.vote.byId->DataLoader.load(auction.id) {
  | None => panic("Did not find auction settled with that ID")
  | Some(vote) => vote
  }
}
