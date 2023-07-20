let renderer = Routes.Main.DailyQuestion.Route.makeRenderer(
  ~prepare=props => {
    ()
  },
  ~render=props => {
    <DailyQuestion />
  },
)
