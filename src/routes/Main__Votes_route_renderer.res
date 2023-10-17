module Votes = %relay.deferredComponent(Votes.make)

@val @scope(("import", "meta", "env"))
external votesContractAddress: option<string> = "VITE_VOTES_CONTRACT_ADDRESS"

let renderer = Routes.Main.Votes.Route.makeRenderer(
  ~prepareCode=_ => [Votes.preload()],
  ~prepare=({environment, sortBy}) => {
    switch sortBy {
    | Some(New) =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={
          orderDirection: Desc,
          votesContractAddress: votesContractAddress->Option.getExn,
        },
        ~fetchPolicy=StoreOrNetwork,
      )->Some
    | Some(Old) =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={
          orderDirection: Asc,
          votesContractAddress: votesContractAddress->Option.getExn,
        },
        ~fetchPolicy=StoreOrNetwork,
      )->Some
    | Some(Used) =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={votesContractAddress: votesContractAddress->Option.getExn},
        ~fetchPolicy=StoreOrNetwork,
      )->Some
    | Some(Unused) =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={votesContractAddress: votesContractAddress->Option.getExn},
        ~fetchPolicy=StoreOrNetwork,
      )->Some
    | Some(Owned(Some(address))) =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={
          owner: address,
          votesContractAddress: votesContractAddress->Option.getExn,
        },
        ~fetchPolicy=StoreOrNetwork,
      )->Some
    | Some(Owned(None)) =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={
          votesContractAddress: votesContractAddress->Option.getExn,
        },
        ~fetchPolicy=StoreOnly,
      )->Some
    | None =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={
          orderDirection: Desc,
          votesContractAddress: votesContractAddress->Option.getExn,
        },
      )->Some
    }
  },
  ~render=({prepared: queryRef}) => {
    <ErrorBoundary fallback={({error}) => JSON.stringifyAny(error)->Option.getExn->React.string}>
      <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
        {switch queryRef {
        | Some(queryRef) => <Votes queryRef />
        | None => React.null
        }}
      </React.Suspense>
    </ErrorBoundary>
  },
)
