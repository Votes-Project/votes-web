module TwitterCallback = %relay.deferredComponent(TwitterCallback.make)

let renderer = Routes.Main.Auth.Twitter.Callback.Route.makeRenderer(
  ~prepareCode=_ => [TwitterCallback.preload()],
  ~prepare=({environment, code}) => (),
  // switch code {
  // | None => None
  // | Some(code) =>
  // Some(
  //   TwitterCallbackQuery_graphql.load(
  //     ~environment,
  //     ~variables={code: code},
  //     ~fetchPolicy=StoreOrNetwork,
  //   ),
  // )

  ~render=({prepared}) => <TwitterCallback />,
)
