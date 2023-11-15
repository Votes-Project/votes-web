open Verifications

type data = {verifications: verifications}

@gql.field
let verifications = async (
  _: Schema.query,
  ~context,
  ~ctx: ResGraphContext.context,
): verifications => {
  let data = await ctx.dataLoaders.verifications.byId->DataLoader.load(context)
  switch data {
  | None => panic("Something went wrong fetching from BrightID Node")
  | Some(data) =>
    ctx.dataLoaders.verifications.byId->DataLoader.prime(Some(data))
    data
  }
}
