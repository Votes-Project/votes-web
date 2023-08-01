/** GraphClient: A bid on a Vote Auction */
@gql.type
type auctionBid = {
  ...NodeInterface.node,
  /** The ID of the Vote Token */
  @gql.field
  tokenId: string,
  /** The address of the bidder */
  @gql.field
  bidder: string,
  /** The amount of the bid */
  @gql.field
  amount: string,
  /** The time the bid was made */
  @gql.field
  blockTimestamp: string,
}

/** An edge to an auction bid. */
@gql.type
type auctionBidEdge = ResGraph.Connections.edge<auctionBid>

/** A connection to a todo. */
@gql.type
type auctionBidConnection = ResGraph.Connections.connection<auctionBidEdge>
