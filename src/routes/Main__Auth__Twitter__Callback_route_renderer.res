module TwitterCallback = %relay.deferredComponent(TwitterCallback.make)

let renderer = Routes.Main.Auth.Twitter.Callback.Route.makeRenderer(
  ~prepareCode=_ => [TwitterCallback.preload()],
  ~prepare=_ => (),
  ~render=_ => <TwitterCallback />,
)
