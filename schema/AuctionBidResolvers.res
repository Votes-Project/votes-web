open AuctionBid

/* Takes a Graphclient or Global Object ID and returns a single AuctionBid Item */
@gql.field
let auctionBid = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
  auctionBid,
> => {
  let id =
    id->ResGraph.Utils.Base64.decode->String.split(":")->Array.get(1)->Option.getWithDefault(id)
  switch await ctx.dataLoaders.auctionBid.byId->DataLoader.load(id) {
  | None => panic("Did not find auction bid with that ID")
  | Some(auctionBid) => auctionBid->Some
  }
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
  ~ctx: ResGraphContext.context,
): option<auctionBidConnection> => {
  let bids =
    await ctx.dataLoaders.auctionBid.list->DataLoader.load({first, orderBy, orderDirection, where})
  bids->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})->Some
}
