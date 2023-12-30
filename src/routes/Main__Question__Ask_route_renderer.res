module AskQuestion = %relay.deferredComponent(AskQuestion.make)

let renderer = Routes.Main.Question.Ask.Route.makeRenderer(
  ~prepareCode=_ => [AskQuestion.preload()],
  ~prepare=_ => (),
  ~render=_ => {
    <AskQuestion />
  },
)
