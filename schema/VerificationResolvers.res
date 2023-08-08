open Verification

type data = {data: verification}

@gql.field
let verification = async (_: Schema.query, ~contextId, ~ctx: ResGraphContext.context): option<
  verification,
> => {
  let data = await ctx.dataLoaders.verification.byId->DataLoader.load(contextId)
  switch data {
  | None => panic("Did not find verification with that ID")
  | Some(data) => Some(data)
  }
}
