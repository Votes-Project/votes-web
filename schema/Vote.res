/** GraphClient: A Vote Token entity */
@gql.type
type vote = {
  ...NodeInterface.node,
  /* The token ID of the vote token */
  @gql.field
  tokenId: string,
  /* The owner of the vote token */
  @gql.field
  owner: string,
  /* The IPFS uri of the vote token */
  @gql.field
  uri: string,
  /* The contract of the vote token */
  contract: VoteContract.voteContract,
}

/** An edge to a vote entity. */
@gql.type
type voteEdge = ResGraph.Connections.edge<vote>

/** A connection of votes . */
@gql.type
type voteConnection = ResGraph.Connections.connection<voteEdge>
