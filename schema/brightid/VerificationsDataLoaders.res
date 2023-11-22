type t = {byId: DataLoader.t<string, Verifications.verifications>}

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    open Fetch
    open BrightID_Shared
    let url = verificationsUrl ++ id
    switch await fetch(url, {})->Promise.then(Response.json) {
    | exception e =>
      switch e {
      | Exn.Error(e) if e->Exn.name->Option.isSome =>
        Verifications.BrightIdError({
          errorMessage: e->Exn.name->Option.getWithDefault("Unknown Error"),
          code: -1,
          errorNum: -1,
          error: true,
        })
      | _ =>
        Verifications.BrightIdError({
          errorMessage: "Unknown Error",
          code: -1,
          errorNum: -1,
          error: true,
        })
      }

    | json =>
      let verifications = json->S.parseWith(dataStruct(Verifications.verificationsStruct))
      let error = json->S.parseWith(errorStruct)

      switch (verifications, error) {
      | (Ok({data: {contextIds, count}}), _) =>
        Verifications.Verifications({
          id,
          contextIds,
          count,
        })
      | (_, Ok(error)) => Verifications.BrightIdError(error)
      | (Error(_), Error(_)) =>
        Verifications.BrightIdError({
          errorMessage: "Unknown Error",
          code: -1,
          errorNum: -1,
          error: true,
        })
      }
    }
  }),
}
