/* GraphClient: A combined object of AuctionCreated, AuctionSettled, and AuctionBids */
@gql.type
type auction = {
  ...NodeInterface.node,
  /* Vote token id */
  @gql.field
  tokenId: string,
  /* Start time of auction */
  @gql.field
  startTime: string,
  /* End time of auction */
  @gql.field
  endTime: string,
  /* Amount of highest bid */
  @gql.field
  amount: string,
  /* Address of highest bidder */
  @gql.field
  bidder: string,
  /* True if auction is extended past end time */
  @gql.field
  extended: bool,
  /* True if auction has ended */
  @gql.field
  settled: bool,
}

/** An edge to an auction. */
@gql.type
type auctionEdge = ResGraph.Connections.edge<auction>

/** A connection to an auction. */
@gql.type
type auctionConnection = ResGraph.Connections.connection<auctionEdge>
