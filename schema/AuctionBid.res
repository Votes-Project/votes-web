/** GraphClient: A bid on a Vote Auction */
@gql.type
type auctionBid = {
  ...NodeInterface.node,
  tokenId: string,
  /** The address of the bidder */
  @gql.field
  bidder: string,
  amount: string,
  /** The time the bid was made */
  @gql.field
  blockTimestamp: string,
}

/** An edge to an auction bid. */
@gql.type
type auctionBidEdge = ResGraph.Connections.edge<auctionBid>

/** A connection of auction bids. */
@gql.type
type auctionBidConnection = ResGraph.Connections.connection<auctionBidEdge>
