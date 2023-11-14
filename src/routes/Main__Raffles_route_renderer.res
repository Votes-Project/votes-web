@val @scope(("import", "meta", "env"))
external votesContractAddress: option<string> = "VITE_VOTES_CONTRACT_ADDRESS"
let votesContractAddress = votesContractAddress->Option.map(address => address->String.toLowerCase)

module Raffles = %relay.deferredComponent(Raffles.make)
let renderer = Routes.Main.Raffles.Route.makeRenderer(
  ~prepareCode=_ => [Raffles.preload()],
  ~prepare=({environment}) => {
    RafflesQuery_graphql.load(
      ~environment,
      ~variables={
        votesContractAddress: votesContractAddress->Option.getExn,
      },
      ~fetchPolicy=StoreOrNetwork,
    )
  },
  ~render=({prepared: queryRef}) => {
    <Raffles queryRef />
  },
)
