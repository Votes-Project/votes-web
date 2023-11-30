@gql.type
type twitterToken = {
  ...NodeInterface.node,
  /* Type of token */
  @gql.field
  tokenType: string,
  /* Time till token expires in seconds */
  @gql.field
  expiresIn: int,
  /* Access token */
  @gql.field
  accessToken: string,
  /* Refresh token */
  @gql.field
  refreshToken?: string,
  /* Scope of token */
  @gql.field
  scope: string,
}

@gql.type
type twitterOAuthError = {
  /* Error string */
  @gql.field
  error: string,
  /* Error description */
  @gql.field
  errorDescription: string,
}

@gql.union
type twitterOAuthResponse = Token(twitterToken) | Error(twitterOAuthError)
