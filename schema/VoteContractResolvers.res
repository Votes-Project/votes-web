open VoteContract
@gql.field
let voteContract = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
  voteContract,
> => {
  let id =
    id->ResGraph.Utils.Base64.decode->String.split(":")->Array.get(1)->Option.getWithDefault(id)
  switch await ctx.dataLoaders.voteContract.byId->DataLoader.load(id) {
  | None => panic("Did not find vote contract with that ID")
  | Some(voteContract) =>
    ctx.dataLoaders.voteContract.byId->DataLoader.prime(voteContract->Some)
    voteContract->Some
  }
}

/* The total supply of the vote token */
@gql.field
let totalSupply = async (voteContract: voteContract): Schema.BigInt.t =>
  voteContract.totalSupply->BigInt.fromString

@gql.field
let address = async (voteContract: voteContract) => voteContract.id
