module Votes = %relay.deferredComponent(Votes.make)

let renderer = Routes.Votes.Route.makeRenderer(
  ~prepareCode=_ => [Votes.preload()],
  ~prepare=({environment}) => {
    // HINT: This returns a single query ref, but remember you can return _anything_ from here - objects, arrays, tuples, whatever. A hot tip is to return an object that doesn't require a type definition, to leverage type inference.
    VotesQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork)
  },
  ~render=({prepared: queryRef}) => {
    <Votes queryRef />
  },
)
