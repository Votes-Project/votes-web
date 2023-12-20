type question = Main_QuestionConnectionFragment_graphql.Types.fragment_questionConnection_edges_node

type context = {
  question: option<question>,
  setQuestion: (option<question> => option<question>) => unit,
}

let context = React.createContext({
  question: None,
  setQuestion: _ => (),
})

module Provider = {
  let make = React.Context.provider(context)
}
