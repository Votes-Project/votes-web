type question = RescriptRelay.fragmentRefs<[#BottomNav_question | #SingleQuestion_node]>

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
