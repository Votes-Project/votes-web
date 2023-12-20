module Raffles = %relay.deferredComponent(Raffles.make)
let renderer = Routes.Main.Raffles.Route.makeRenderer(
  ~prepareCode=_ => [Raffles.preload()],
  ~prepare=({environment}) => {
    RafflesQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork)
  },
  ~render=({prepared: queryRef}) => {
    <Raffles queryRef />
  },
)
