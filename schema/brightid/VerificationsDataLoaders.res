type t = {byId: DataLoader.t<string, option<Verifications.verifications>>}

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    open Fetch
    open BrightID_Shared
    let url = verificationsUrl ++ id
    switch await fetch(url, {})->Promise.then(Response.json) {
    | exception e =>
      switch e {
      | Exn.Error(e) if e->Exn.name == Some("SyntaxError") =>
        Verifications.BrightIdError({
          errorMessage: "SyntaxError",
          code: -1,
          errorNum: -1,
          error: true,
        })->Some
      | _ =>
        Verifications.BrightIdError({
          errorMessage: "Unknown Error",
          code: -1,
          errorNum: -1,
          error: true,
        })->Some
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
        })->Some
      | (_, Ok(error)) => Verifications.BrightIdError(error)->Some
      | (Error(_), Error(_)) => None
      }
    }
  }),
}
