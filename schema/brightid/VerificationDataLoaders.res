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
        Some(Boolean(unique)),
        Some(String(app)),
        Some(String(context)),
        Some(Array(contextIdsRaw)),
        timestamp,
        sig,
        publicKey,
      ) =>
      Some({
        unique,
        app,
        context,
        contextIds: contextIdsRaw->Array.filterMap(contextId =>
          switch contextId {
          | String(contextId) => Some(contextId)
          | _ => None
          }
        ),
        timestamp: switch timestamp {
        | Some(Number(timestamp)) => timestamp
        | _ => 0.
        },
        sig: switch sig {
        | Some(String(sig)) => sig
        | _ => ""
        },
        publicKey: switch publicKey {
        | Some(String(publicKey)) => publicKey
        | _ => ""
        },
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
        Some(Boolean(error)),
        Some(Number(errorNumRaw)),
        Some(String(errorMessage)),
        Some(Number(codeRaw)),
      ) =>
      Some({
        error,
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
      let verification = decodeData(json)->Option.map(verification => {
        let answerId = verification.contextIds->Array.get(0)->Option.getUnsafe
        Verification.Verification({
          id: answerId,
          unique: verification.unique,
          app: verification.app,
          context: verification.context,
          contextIds: verification.contextIds,
        })
      })
      switch verification {
      | Some(Verification({id: answerId})) =>
        if answerId == id {
          verification
        } else {
          switch await BrightID.SDK.verifyContextId(~context, ~contextId=answerId) {
          | exception e => raise(e)
          | json =>
            let verification = decodeData(json)->Option.getExn
            Verification.Verification({
              id: answerId,
              unique: verification.unique,
              app: verification.app,
              context: verification.context,
              contextIds: verification.contextIds,
            })->Some
          }
        }
      | _ => verification
      }
    }
  }),
}
