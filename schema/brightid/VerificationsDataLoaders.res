type t = {byId: DataLoader.t<string, option<Verifications.verifications>>}

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    open Fetch
    open BrightID_Shared
    let url = verificationsUrl ++ id

    switch await fetch(url, {}) {
    | exception e =>
      Console.error2("e: ", e)
      None
    | res =>
      let json = await res->Fetch.Response.json

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
