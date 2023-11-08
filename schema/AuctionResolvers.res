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
): auctionConnection => {
  let auctions =
    await ctx.dataLoaders.auction.list->DataLoader.load({first, orderBy, orderDirection, where})

  auctions->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
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

  bids->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
}

@gql.field
let vote = async (auction: auction, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.vote.byId->DataLoader.load(auction.id) {
  | None => panic("Did not find vote with that ID")
  | Some(vote) => // ctx.dataLoaders.vote.byId->DataLoader.prime(Some(vote))
    vote
  }
}

/* Start time of auction */
@gql.field
let startTime = (auction: auction): Schema.Timestamp.t =>
  auction.startTime->Float.fromString->Option.map(x => x *. 1000.)->Option.getExn->Date.fromTime

/* End time of auction */
@gql.field
let endTime = (auction: auction): Schema.Timestamp.t =>
  auction.endTime->Float.fromString->Option.map(x => x *. 1000.)->Option.getExn->Date.fromTime

/* Token ID of auction */
@gql.field
let tokenId = (auction: auction): Schema.BigInt.t => auction.tokenId->BigInt.fromString

/* Amount of highest bid */
@gql.field
let amount = (auction: auction): Schema.BigInt.t => auction.amount->BigInt.fromString
