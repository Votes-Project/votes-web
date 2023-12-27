module Votes = %relay.deferredComponent(Votes.make)

let renderer = Routes.Main.Votes.Route.makeRenderer(
  ~prepareCode=_ => [Votes.preload()],
  ~prepare=({environment, sortBy}) => {
    switch sortBy {
    | Some(New) =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={
          orderDirection: Desc,
        },
        ~fetchPolicy=StoreOrNetwork,
      )->Some
    | Some(Old) =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={
          orderDirection: Asc,
        },
        ~fetchPolicy=StoreOrNetwork,
      )->Some
    | Some(Used) =>
      VotesQuery_graphql.load(~environment, ~variables={}, ~fetchPolicy=StoreOrNetwork)->Some
    | Some(Unused) =>
      VotesQuery_graphql.load(~environment, ~variables={}, ~fetchPolicy=StoreOrNetwork)->Some
    | Some(Owned(Some(address))) =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={
          where: {owner: address},
        },
        ~fetchPolicy=StoreOrNetwork,
      )->Some
    | Some(Owned(None)) =>
      VotesQuery_graphql.load(~environment, ~variables={}, ~fetchPolicy=StoreOnly)->Some
    | None =>
      VotesQuery_graphql.load(
        ~environment,
        ~variables={
          orderBy: TokenId,
          orderDirection: Desc,
        },
      )->Some
    }
  },
  ~render=({prepared: queryRef}) => {
    <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
      <ErrorBoundary fallback={({error}) => JSON.stringifyAny(error)->Option.getExn->React.string}>
        {switch queryRef {
        | Some(queryRef) => <Votes queryRef />

        | None => React.null
        }}
      </ErrorBoundary>
    </React.Suspense>
  },
)
