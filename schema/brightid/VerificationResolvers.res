open Verification

type data = {verification: verification}

@gql.field
let verification = async (
  _: Schema.query,
  ~contextId,
  ~ctx: ResGraphContext.context,
): verification => {
  switch await ctx.dataLoaders.verification.byId->DataLoader.load(contextId) {
  | None => panic("Something went wrong fetching from BrightID Node")
  | Some(verification) =>
    switch verification {
    | Verification.Verification({contextIds}) =>
      switch contextIds->Array.get(0) {
      | Some(answerServiceId) if answerServiceId == contextId =>
        ctx.dataLoaders.verification.byId->DataLoader.prime(Some(verification))
        verification
      | Some(answerServiceId) =>
        switch await ctx.dataLoaders.verification.byId->DataLoader.load(answerServiceId) {
        | None => panic("Something went wrong fetching from BrightID Node")
        | Some(verification) =>
          ctx.dataLoaders.verification.byId->DataLoader.prime(Some(verification))
          verification
        }
      | None => verification
      }
    | _ => verification
    }
  }
}
