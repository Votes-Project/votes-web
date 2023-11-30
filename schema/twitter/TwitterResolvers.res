@val @scope(("process", "env"))
external vercelUrl: option<string> = "VERCEL_URL"

@gql.field
let setTwitterToken = async (_: Schema.mutation, ~code, ~ctx: ResGraphContext.context) => {
  switch await ctx.dataLoaders.twitter.token->DataLoader.load(code) {
  | None => None
  | Some(token) =>
    switch (token, ctx.request->ResGraphContext.Request.cookieStore) {
    | (Token(token), Some(c)) =>
      await c->CookieStore.setWithOptions({
        name: "votes_twitter_accessToken",
        expires: float(token.expiresIn),
        value: token.accessToken,
        sameSite: Lax,
        domain: vercelUrl
        ->Option.flatMap(url => url->String.split(":")->Array.get(0))
        ->Option.getWithDefault("localhost"),
        // path: "/auth/twitter/callback",
      })

    | _ => panic("Could not set access token cookie")
    }
    Some(token)
  }
}

@gql.field
let postTweet = async (_: Schema.mutation, ~input, ~ctx: ResGraphContext.context) => {
  switch ctx.request->ResGraphContext.Request.cookieStore {
  | Some(c) =>
    switch await c->CookieStore.get(Name("votes_twitter_accessToken")) {
    | Some(accessToken) =>
      switch await ctx.mutations.twitter.sendTweet(input, accessToken.value) {
      | Some(tweet) => Some(tweet)
      | None => None
      }
    | None => None
    }
  | None => None
  }
}
