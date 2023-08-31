open Verification

type data = {verification: verification}

@gql.field
let verification = async (
  _: Schema.query,
  ~contextId,
  ~ctx: ResGraphContext.context,
): verification => {
  let data = await ctx.dataLoaders.verification.byId->DataLoader.load(contextId)
  switch data {
  | None => panic("Something went wrong fetching from BrightID Node")
  | Some(data) => data
  }
}
