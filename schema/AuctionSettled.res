/** A single todo item. */
@gql.type
type auctionSettled = {
  ...NodeInterface.node,
  /** Winner of auction */
  @gql.field
  winner: string,
  /** ID of Votes token **/
  @gql.field
  tokenId: string,
}

/** An edge to a settledAuction. */
@gql.type
type auctionSettledEdge = ResGraph.Connections.edge<auctionSettled>

/** A connection to a todo. */
@gql.type
type auctionSettledConnection = ResGraph.Connections.connection<auctionSettledEdge>
