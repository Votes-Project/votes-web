type context = {
  content: string,
  setContent: (string => string) => unit,
}

let context = React.createContext({
  content: "",
  setContent: _ => (),
})

module Provider = {
  let make = React.Context.provider(context)
}
