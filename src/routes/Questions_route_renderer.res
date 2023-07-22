module Questions = %relay.deferredComponent(Questions.make)

let renderer = Routes.Questions.Route.makeRenderer(
  ~prepareCode=_ => [Questions.preload()],
  ~prepare=({environment}) => {
    QuestionsQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork)
  },
  ~render=({prepared: queryRef}) => {
    <Questions queryRef />
  },
)
