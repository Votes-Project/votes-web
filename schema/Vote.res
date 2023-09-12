/** GraphClient: A Vote Token entity */
@gql.type
type vote = {
  ...NodeInterface.node,
  /* The owner of the vote token */
  @gql.field
  owner: string,
  /* The IPFS uri of the vote token */
  @gql.field
  uri: string,
}

/** An edge to a vote entity. */
@gql.type
type voteEdge = ResGraph.Connections.edge<vote>

/** A connection of votes . */
@gql.type
type voteConnection = ResGraph.Connections.connection<voteEdge>
