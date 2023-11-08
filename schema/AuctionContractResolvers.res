open AuctionContract
@gql.field
let auctionContract = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
  auctionContract,
> => {
  let id =
    id->ResGraph.Utils.Base64.decode->String.split(":")->Array.get(1)->Option.getWithDefault(id)
  switch await ctx.dataLoaders.auctionContract.byId->DataLoader.load(id) {
  | None => panic("Did not find auction settled with that ID")
  | Some(auctionContract) => auctionContract->Some
  }
}

@gql.field
let auctions = async (
  _: auctionContract,
  ~orderBy: option<AuctionDataLoaders.orderBy_Auctions>,
  ~orderDirection,
  ~where,
  ~first,
  ~after,
  ~before,
  ~last,
  ~ctx: ResGraphContext.context,
): Auction.auctionConnection => {
  let auctions =
    await ctx.dataLoaders.auction.list->DataLoader.load({first, orderBy, orderDirection, where})

  auctions->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
}

/* Auction Minimum Bid Increment */
@gql.field
let minBidIncrement = async (auctionContract: auctionContract): Schema.BigInt.t => {
  auctionContract.minBidIncrement->BigInt.fromString
}
/* Auction Reserve Price */
@gql.field
let reservePrice = async (auctionContract: auctionContract): Schema.BigInt.t => {
  auctionContract.reservePrice->BigInt.fromString
}
