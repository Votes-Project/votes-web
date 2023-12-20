type auction = Main_VoteConnectionFragment_graphql.Types.fragment_voteConnection_edges_node_auction

type context = {
  auction: option<auction>,
  setAuction: (option<auction> => option<auction>) => unit,
  isLoading: bool,
  setIsLoading: (bool => bool) => unit,
}

let context = React.createContext({
  auction: None,
  setAuction: _ => (),
  isLoading: true,
  setIsLoading: _ => (),
})

module Provider = {
  let make = React.Context.provider(context)
}
