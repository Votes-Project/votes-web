module Votes = %relay.deferredComponent(Votes.make)

let renderer = Routes.Votes.Route.makeRenderer(
  ~prepareCode=_ => [Votes.preload()],
  ~prepare=_ => {
    ()
  },
  ~render=_ => {
    <Votes />
  },
)
