/** GraphClient: A Votes Auction */
@gql.type
type auctionCreated = {
  ...NodeInterface.node,
  /** ID of Votes token **/
  @gql.field
  tokenId: string,
  /** Start time of auction **/
  @gql.field
  startTime: string,
  /** End time of auction **/
  @gql.field
  endTime: string,
}

/** An edge to an auction. */
@gql.type
type auctionCreatedEdge = ResGraph.Connections.edge<auctionCreated>

/** A connection to a todo. */
@gql.type
type auctionCreatedConnection = ResGraph.Connections.connection<auctionCreatedEdge>
