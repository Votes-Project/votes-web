module Votes = %relay.deferredComponent(Votes.make)

let renderer = Routes.Main.Votes.Route.makeRenderer(
  ~prepareCode=_ => [Votes.preload()],
  ~prepare=({environment}) => {
    VotesQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork)
  },
  ~render=({prepared: queryRef}) => {
    <Votes queryRef />
  },
)
