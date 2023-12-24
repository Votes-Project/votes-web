module SingleQuestion = %relay.deferredComponent(SingleQuestion.make)

let renderer = Routes.Main.Question.Details.Route.makeRenderer(
  ~prepareCode=_ => [SingleQuestion.preload()],
  ~prepare=({environment, question}) => {
    SingleQuestionQuery_graphql.load(
      ~environment,
      ~variables={id: question},
      ~fetchPolicy=StoreOrNetwork,
    )
  },
  ~render=({prepared: queryRef}) => {
    <SingleQuestion queryRef />
  },
)
