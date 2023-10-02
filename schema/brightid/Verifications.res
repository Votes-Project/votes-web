/* A list of all context ids */
@gql.type
type verificationsData = {
  ...NodeInterface.node,
  /* The list of context ids */
  @gql.field
  contextIds: array<string>,
  /* The number of context ids */
  @gql.field
  count: int,
}

// /** Verification data type */
@gql.union
type verifications = Verifications(verificationsData) | BrightIdError(BrightID_Shared.error)

let verificationsStruct = {
  open S
  object(({field}): BrightID.Verifications.t => {
    contextIds: "contextIds"->field(array(string)),
    count: "count"->field(int),
  })
}
