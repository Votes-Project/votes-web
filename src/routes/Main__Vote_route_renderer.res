@val @scope(("import", "meta", "env"))
external voteContractAddress: option<string> = "VITE_VOTES_CONTRACT_ADDRESS"

exception NoVoteContractAddress
let voteContractAddress = switch voteContractAddress {
| None => raise(NoVoteContractAddress)
| Some(address) => address
}

module SingleVote = %relay.deferredComponent(SingleVote.make)

let renderer = Routes.Main.Vote.Route.makeRenderer(
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
        ~variables={id, voteContractAddress},
        ~fetchPolicy=StoreAndNetwork,
      )->Some
    }
  },
  ~render=({childRoutes, tokenId, prepared}) => {
    let tokenId = tokenId->Int.fromString

    <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
      {switch prepared {
      | Some(queryRef) => <SingleVote queryRef tokenId> {childRoutes} </SingleVote>
      | None => <div> {"Failed to fetch vote..."->React.string} </div>
      }}
    </React.Suspense>
  },
)
