let renderer = Routes.Main.Queue.Route.makeRenderer(
  ~prepare=props => {
    ()
  },
  ~render=props => {
    <div> {React.string("Queue")} </div>
  },
)
