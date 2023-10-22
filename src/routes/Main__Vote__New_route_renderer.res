module CreateVote = %relay.deferredComponent(CreateVote.make)

let renderer = Routes.Main.Vote.New.Route.makeRenderer(
  ~prepareCode=_ => [CreateVote.preload()],
  ~prepare=_ => (),
  ~render=({childRoutes}) => {
    <CreateVote> {childRoutes} </CreateVote>
  },
)
