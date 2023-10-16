module Votes = %relay.deferredComponent(Votes.make)

@val @scope(("import", "meta", "env"))
external votesContractAddress: option<string> = "VITE_VOTES_CONTRACT_ADDRESS"

let renderer = Routes.Main.Votes.Route.makeRenderer(
  ~prepareCode=_ => [Votes.preload()],
  ~prepare=({environment}) => {
    VotesQuery_graphql.load(
      ~environment,
      ~variables={votesContractAddress: votesContractAddress->Option.getExn},
      ~fetchPolicy=StoreOrNetwork,
    )
  },
  ~render=({prepared: queryRef}) => {
    <ErrorBoundary fallback={({error}) => JSON.stringifyAny(error)->Option.getExn->React.string}>
      <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
        <Votes queryRef />
      </React.Suspense>
    </ErrorBoundary>
  },
)
