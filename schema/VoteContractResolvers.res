open VoteContract
type data = {voteContract: voteContract}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetVoteDocument"

@gql.field
let voteContract = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
  voteContract,
> => {
  switch await ctx.dataLoaders.voteContract.byId->DataLoader.load(id) {
  | None => panic("Did not find auction settled with that ID")
  | Some(voteContract) => voteContract->Some
  }
}
