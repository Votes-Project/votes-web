/** GraphClient: A Transfer Event for a Vote token */
@gql.type
type voteTransfer = {
  ...NodeInterface.node,
  /* The tokenID of the token being transferred */
  @gql.field
  tokenId: string,
  /* The address of the recipient */
  @gql.field
  to: string,
  /* The transaction hash of the transfer */
  @gql.field
  transactionHash: string,
  /* The block number of the transfer */
  @gql.field
  blockNumber: int,
}

/** An edge to a vote transfer event. */
@gql.type
type voteTransferEdge = ResGraph.Connections.edge<voteTransfer>

/** A connection to a vote transfer. */
@gql.type
type voteTransferConnection = ResGraph.Connections.connection<voteTransferEdge>
