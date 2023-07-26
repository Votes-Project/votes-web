/** GraphClient: A Votes Auction */
@gql.type
type auctionCreated = {
  ...NodeInterface.node,
  /** ID of Votes token **/
  @gql.field
  tokenId: string,
}

/** An edge to an auction. */
@gql.type
type auctionCreatedEdge = ResGraph.Connections.edge<auctionCreated>

/** A connection to a todo. */
@gql.type
type auctionCreatedConnection = ResGraph.Connections.connection<auctionCreatedEdge>
