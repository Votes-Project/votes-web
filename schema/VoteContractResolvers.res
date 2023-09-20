open VoteContract
@gql.field
let voteContract = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
  voteContract,
> => {
  let id =
    id->ResGraph.Utils.Base64.decode->String.split(":")->Array.get(1)->Option.getWithDefault(id)
  switch await ctx.dataLoaders.voteContract.byId->DataLoader.load(id) {
  | None => panic("Did not find auction settled with that ID")
  | Some(voteContract) => voteContract->Some
  }
}
