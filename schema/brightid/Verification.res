/** Data fields from a verified contextID */
@gql.type
type verificationData = {
  ...NodeInterface.node,
  /** the key of app */
  @gql.field
  app: string,
  /** The context the contextID is linked to. This should always be Votes */
  @gql.field
  context: string,
  /** Bool value denoting whether the BrightID is owned by a unique human */
  @gql.field
  unique: bool,
  /** Array of ids linked to the Votes context */
  @gql.field
  contextIds: array<string>,
  /** The timestamp of the verification */
  @gql.field
  timestamp?: float,
  /** The signature of the verification */
  @gql.field
  sig?: string,
  /** The public key of the verification */
  @gql.field
  publicKey?: string,
}

// /** Verification data type */
@gql.union
type verification = Verification(verificationData) | BrightIdError(BrightID_Shared.error)
