open Verifications

type data = {verifications: verifications}

@gql.field
let verifications = async (
  _: Schema.query,
  ~context,
  ~ctx: ResGraphContext.context,
): verifications => {
  let verifications = await ctx.dataLoaders.verifications.byId->DataLoader.load(context)
  ctx.dataLoaders.verifications.byId->DataLoader.prime(verifications)
  verifications
}
