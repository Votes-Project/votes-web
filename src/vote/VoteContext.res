type vote = RescriptRelay.fragmentRefs<[#SingleVote_node]>

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
