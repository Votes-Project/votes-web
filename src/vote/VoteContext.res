type vote = Main_VoteConnectionFragment_graphql.Types.fragment_voteConnection_edges_node

type context = {
  vote: option<vote>,
  setVote: (option<vote> => option<vote>) => unit,
}

let context = React.createContext({
  vote: None,
  setVote: _ => (),
})

module Provider = {
  let make = React.Context.provider(context)
}
