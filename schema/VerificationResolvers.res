open Verification

type data = {verification: verification}

@gql.field
let verification = async (_: Schema.query, ~contextId, ~ctx: ResGraphContext.context): option<
  verification,
> => {
  let data = await ctx.dataLoaders.verification.byId->DataLoader.load(contextId)
  Js.log2("data: ", data)

  switch data {
  | None => panic("Something went wrong fetching from BrightID Node")
  | Some(data) => Some(data)
  }
}
