@val @scope(("import", "meta", "env"))
external twitterClientId: option<string> = "VITE_TWITTER_CLIENT_ID"

let contextId = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_contextId")
module OAuth = {
  let twitterState = contextId->Option.getExn

  let twitterCodeChallenge = "challenge"
  let twitterAuthUrl = "https://twitter.com/i/oauth2/authorize"
  let twitterScope =
    ["tweet.write", "follows.write", "users.read", "tweet.read"]->Array.joinWith(" ")

  let getTwitterOAuthUrl = redirectPath => {
    let redirectUri = window->Window.location->Window.Location.origin ++ redirectPath
    let params = Dict.fromArray([
      ("response_type", "code"),
      ("client_id", twitterClientId->Option.getExn),
      ("redirect_uri", redirectUri),
      ("scope", twitterScope),
      ("state", twitterState),
      ("code_challenge", twitterCodeChallenge),
      ("code_challenge_method", "plain"),
    ])

    Helpers.getURLWithQueryParams(twitterAuthUrl, params)
  }
}

module Button = {
  @react.component
  let make = () => {
    let href = Routes.Main.Auth.Twitter.Callback.Route.makeLink()->OAuth.getTwitterOAuthUrl

    <a href>
      <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
        {"Login with Twitter"->React.string}
      </button>
    </a>
  }
}

@react.component
let make = () => <> </>
