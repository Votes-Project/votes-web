module SingleVote = %relay.deferredComponent(SingleVote.make)

let renderer = Routes.Main.Vote.Auction.Route.makeRenderer(
  ~prepareCode=_ => {
    [SingleVote.preload()->Some]->Array.filterMap(v => v)
  },
  ~prepare=({environment, tokenId}) => {
    let id = tokenId->Helpers.tokenToSubgraphId->Helpers.idToGlobalId("Vote")
    switch id {
    | None => None
    | Some(id) =>
      SingleVoteQuery_graphql.load(
        ~environment,
        ~variables={id: id},
        ~fetchPolicy=StoreOrNetwork, //@TODO: This should change to fetch from network on first time loading then store after the rest have loaded in
      )->Some
    }
  },
  ~render=({prepared}) => {
    <ErrorBoundary fallback={({error}) => JSON.stringifyAny(error)->Option.getExn->React.string}>
      <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
        {switch prepared {
        | Some(queryRef) => <SingleVote queryRef />

        | None => <div> {"Failed to fetch vote..."->React.string} </div>
        }}
      </React.Suspense>
    </ErrorBoundary>
  },
)
