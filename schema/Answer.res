@gql.type
type answer = {
  ...NodeInterface.node,
  /** The user that submitted the answer */
  @gql.field
  user: string,
  @gql.field
  option: string,
  @gql.field
  answerNumByUser: int,
  @gql.field
  day: int,
}

/** An edge to an auction. */
@gql.type
type answerEdge = ResGraph.Connections.edge<answer>

/** A connection to an auction. */
@gql.type
type answerConnection = ResGraph.Connections.connection<answerEdge>

@gql.field
let answer = (_: Schema.query): option<answer> => {
  None
}
