@val @scope(("import", "meta", "env")) @return(nullable)
external nodeEnv: option<string> = "VITE_NODE_ENV"

let contextId = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_contextId")

module SetTokenMutation = %relay(`
  mutation TwitterCallbackSetTokenMutation($code: String!) {
    setTwitterToken(code: $code) {
      ... on TwitterToken {
        accessToken
        refreshToken
      }
      ... on TwitterOAuthError {
        error
        errorDescription
      }
    }
  }
`)

@react.component @relay.deferredComponent
let make = () => {
  let (mutate, isMutating) = SetTokenMutation.use()

  let {queryParams, setParams} = Routes.Main.Auth.Twitter.Route.useQueryParams()

  let {replace} = RelayRouter.Utils.useRouter()

  let removeTwitterParams = () => {
    setParams(~navigationMode_=Replace, ~setter=c => {
      ...c,
      state: None,
      code: None,
    })
  }

  React.useEffect0(() => {
    switch queryParams.code {
    | Some(code) if contextId == queryParams.state =>
      let _ = mutate(~variables={code: code}, ~onCompleted=(response, _) => {
        switch response.setTwitterToken {
        | Some(TwitterToken({accessToken})) =>
          open Dom.Storage2
          localStorage->setItem("votes_twitter_accessToken", accessToken)
          document->Document.setCookie("votes_twitter_accessToken=" ++ accessToken)
          removeTwitterParams()
          replace(Routes.Main.Question.Current.Route.makeLink())
        | Some(TwitterOAuthError({error, errorDescription})) =>
          window->Window.alert("Twitter OAuth Error: " ++ error ++ " - " ++ errorDescription)
          removeTwitterParams()
          replace(Routes.Main.Question.Current.Route.makeLink())
        | _ =>
          window->Window.alert("Twitter OAuth Error: Unknown")
          removeTwitterParams()
          replace(Routes.Main.Question.Current.Route.makeLink())
        }
      })
    | Some(_) =>
      window->Window.alert(
        "Local State is out of sync with Twitter API. This could indicate a potential data breach.",
      )
      Routes.Main.Question.Current.Route.makeLink()->replace
    | None => replace(Routes.Main.Question.Current.Route.makeLink())
    }

    None
  })
  isMutating
    ? <div className="text-3xl flex flex-1 justify-center items-center-full h-full">
        {"Authenticating Twitter..."->React.string}
      </div>
    : React.null
}
