let decodeData = json => {
  open BrightID.Verification
  switch json {
  | Js.Json.Object(dict) =>
    switch (
      dict->Dict.get("unique"),
      dict->Dict.get("app"),
      dict->Dict.get("context"),
      dict->Dict.get("contextIds"),
      dict->Dict.get("timestamp"),
      dict->Dict.get("sig"),
      dict->Dict.get("publicKey"),
    ) {
    | (
        Some((True | False) as unique),
        Some(String(app)),
        Some(String(context)),
        Some(Array(contextIdsRaw)),
        Some(Number(timestampRaw)),
        Some(String(sig)),
        Some(String(publicKey)),
      ) =>
      Some({
        unique: switch unique {
        | True => true
        | False => false
        | _ => false
        },
        app,
        context,
        contextIds: contextIdsRaw->Array.filterMap(contextId =>
          switch contextId {
          | String(contextId) => Some(contextId)
          | _ => None
          }
        ),
        timestamp: timestampRaw,
        sig,
        publicKey,
      })
    | _ => None
    }
  | _ => None
  }
}

let decodeError = json => {
  open BrightID.Error
  switch json {
  | Js.Json.Object(dict) =>
    switch (
      dict->Dict.get("error"),
      dict->Dict.get("errorNum"),
      dict->Dict.get("errorMessage"),
      dict->Dict.get("code"),
    ) {
    | (
        Some((True | False) as error),
        Some(Number(errorNumRaw)),
        Some(String(errorMessage)),
        Some(Number(codeRaw)),
      ) =>
      Some({
        error: switch error {
        | True => true
        | False => false
        | _ => false
        },
        errorNum: errorNumRaw->Float.toInt,
        errorMessage,
        code: codeRaw->Float.toInt,
      })
    | _ => None
    }
  | _ => None
  }
}

type t = {byId: DataLoader.t<string, option<Verification.verification>>}

let context = "Votes"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await BrightID.SDK.verifyContextId(~context, ~contextId=id) {
    | exception e =>
      let json = switch e {
      | Exn.Error(error) => error->JSON.stringifyAny->Option.map(JSON.parseExn)
      | _ => None
      }
      json->Option.flatMap(json =>
        decodeError(json)->Option.map(
          error =>
            {
              error: error.error,
              errorNum: error.errorNum,
              errorMessage: error.errorMessage,
              code: error.code,
            }->Verification.BrightIdError,
        )
      )
    | json =>
      decodeData(json)->Option.map(verification => {
        let id =
          verification.contextIds
          ->Array.get(0)
          ->Option.getWithDefault(panic("Could not find a context ID"))
        Verification.Verification({
          id,
          unique: verification.unique,
          app: verification.app,
          context: verification.context,
          contextIds: verification.contextIds,
        })
      })
    }
  }),
}
