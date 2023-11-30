@val @scope(("process", "env"))
external twitterClientId: option<string> = "VITE_TWITTER_CLIENT_ID"
@val @scope(("process", "env"))
external twitterClientSecret: option<string> = "VITE_TWITTER_CLIENT_SECRET"

@val @scope(("process", "env"))
external vercelUrl: option<string> = "VERCEL_URL"

let decodeToken = json => {
  open Twitter
  switch json {
  | Js.Json.Object(dict) =>
    switch (
      dict->Dict.get("token_type"),
      dict->Dict.get("expires_in"),
      dict->Dict.get("access_token"),
      dict->Dict.get("refresh_token"),
      dict->Dict.get("scope"),
    ) {
    | (
        Some(String(tokenType)),
        Some(Number(expiresInRaw)),
        Some(String(accessToken)),
        refreshToken,
        Some(String(scope)),
      ) =>
      Some(
        (
          {
            id: accessToken,
            tokenType,
            expiresIn: expiresInRaw->Float.toInt,
            accessToken,
            refreshToken: switch refreshToken {
            | Some(String(refreshToken)) => refreshToken
            | _ => ""
            },
            scope,
          }: Twitter.twitterToken
        ),
      )
    | _ => None
    }
  | _ => None
  }
}

let decodeError = json => {
  open Twitter
  switch json {
  | Js.Json.Object(dict) =>
    switch (dict->Dict.get("error"), dict->Dict.get("error_description")) {
    | (Some(String(error)), Some(String(errorDescription))) =>
      Some({
        error,
        errorDescription,
      })
    | _ => None
    }
  | _ => None
  }
}

let tokenUrl = "https://api.twitter.com/2/oauth2/token"

type t = {token: DataLoader.t<string, option<Twitter.twitterOAuthResponse>>}

external btoa: string => string = "btoa"

let make = () => {
  token: DataLoader.makeSingle(async code => {
    open Fetch

    let baseUrl = "http://" ++ vercelUrl->Option.getWithDefault("localhost:3000")
    let bearer = btoa(`${twitterClientId->Option.getExn}:${twitterClientSecret->Option.getExn}`)

    let body = URLSearchParams.make(
      ~params={
        "code": code,
        "grant_type": "authorization_code",
        "client_id": twitterClientId->Option.getExn,
        "redirect_uri": `${baseUrl}/auth/twitter/callback`,
        "code_verifier": "challenge",
      },
    )
    let json = switch await fetch(
      tokenUrl,
      {
        method: #POST,
        headers: Headers.fromObject({
          "Content-type": "application/x-www-form-urlencoded",
          "Authorization": `Basic ${bearer}`,
        }),
        body: body->URLSearchParams.toString->Body.string,
      },
    ) {
    | exception _ => None
    | res =>
      switch await res->Response.json {
      | exception _ => None
      | json => Some(json)
      }
    }

    switch json->Option.flatMap(decodeToken) {
    | Some(token) => Twitter.Token(token)->Some
    | None =>
      switch json->Option.flatMap(decodeError) {
      | Some(error) => Twitter.Error(error)->Some
      | None => None
      }
    }
  }),
}
