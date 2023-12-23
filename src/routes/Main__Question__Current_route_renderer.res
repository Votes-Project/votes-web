module SingleQuestion = %relay.deferredComponent(SingleQuestion.make)
let renderer = Routes.Main.Question.Current.Route.makeRenderer(
  ~prepareCode=_ => [SingleQuestion.preload()],
  ~prepare=({environment, id}) => {
    let id = id->Option.getWithDefault("")

    SingleQuestionQuery_graphql.load(~environment, ~variables={id: id}, ~fetchPolicy=StoreOrNetwork)
  },
  ~render=({prepared: queryRef}) => {
    <SingleQuestion queryRef />
  },
)
