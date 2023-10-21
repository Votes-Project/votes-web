let renderer = Routes.Main.Question.Current.Route.makeRenderer(
  ~prepare=_ => {
    ()
  },
  ~render=_ => {
    <SingleQuestion />
  },
)
