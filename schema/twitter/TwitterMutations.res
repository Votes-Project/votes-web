type t = {sendTweet: (Twitter.sendTweetInput, string) => promise<option<Twitter.tweet>>}

let twitterApiV2 = "https://api.twitter.com/2/"
let tweetsApi = twitterApiV2 ++ "tweets/"

let make = () => {
  sendTweet: async (input, token) => {
    open Fetch
    let body = JSON.stringifyAny(input)->Option.map(Body.string)->Option.getExn

    switch await fetch(
      tweetsApi,
      {
        method: #POST,
        headers: Headers.fromObject({
          "Content-Type": "application/json",
          "Authorization": "Bearer " ++ token,
        }),
        body,
      },
    ) {
    | exception _ => None
    | res =>
      let json = await res->Response.json
      let tweet = json->S.parseWith(BrightID_Shared.dataStruct(Twitter.tweetStruct))

      switch tweet {
      | Ok(tweet) => Some(tweet.data)
      | Error(_) => None
      }
    }
  },
}
