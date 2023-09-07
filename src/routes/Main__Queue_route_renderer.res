module Queue = %relay.deferredComponent(Queue.make)
let renderer = Routes.Main.Queue.Route.makeRenderer(
  ~prepareCode=_ => [Queue.preload()],
  ~prepare=_ => {
    ()
  },
  ~render=_ => {
    <Queue />
  },
)
