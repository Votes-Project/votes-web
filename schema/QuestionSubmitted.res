/* A submitted question for a given day */
@gql.type
type questionSubmitted = {
  ...NodeInterface.node,
  /** ID of the vote token attached to the question. If the community vote is
  used this will be the zero address */
  @gql.field
  tokenId: string,
  /** Question asked */
  @gql.field
  question: string,
  /** Answer options for the question */
  @gql.field
  options: array<string>,
  @gql.field
  answers?: array<string>,
  @gql.field
  answerNum?: int,
}

/** An edge to a submitted Question. */
@gql.type
type questionSubmittedEdge = ResGraph.Connections.edge<questionSubmitted>

/** A connection to a todo. */
@gql.type
type questionSubmittedConnection = ResGraph.Connections.connection<questionSubmittedEdge>
