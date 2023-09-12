/** GraphClient: A Vote Contract entity */
@gql.type
type voteContract = {
  ...NodeInterface.node,
  /* The name of the vote token */
  @gql.field
  name: string,
  /* The symbol of the vote token */
  @gql.field
  symbol: string,
  /* The total supply of the vote token */
  @gql.field
  totalSupply: string,
}
