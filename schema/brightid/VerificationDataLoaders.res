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
      | Exn.Error(e) if e->Exn.name == Some("SyntaxError") =>
        (
          {
            errorMessage: "SyntaxError",
            code: -1,
            errorNum: -1,
            error: true,
          }: BrightID_Shared.error
        )
        ->JSON.stringifyAny
        ->Option.map(JSON.parseExn)
      | Exn.Error(e)
        if e->Exn.message->Option.map(m => m->String.includes("Unavailable"))->Option.isSome =>
        (
          {
            errorMessage: "UnknownError",
            code: -1,
            errorNum: -1,
            error: true,
          }: BrightID_Shared.error
        )
        ->JSON.stringifyAny
        ->Option.map(JSON.parseExn)
      | Exn.Error(e) => e->JSON.stringifyAny->Option.map(JSON.parseExn)
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
        let answerId = verification.contextIds->Array.get(0)->Option.getUnsafe
        Verification.Verification({
          id: answerId,
          unique: verification.unique,
          app: verification.app,
          context: verification.context,
          contextIds: verification.contextIds,
        })
      })
    }
  }),
}
