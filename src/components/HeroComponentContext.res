type context = {
  heroComponent: React.element,
  setHeroComponent: (React.element => React.element) => unit,
}

let context = React.createContext({heroComponent: React.null, setHeroComponent: _ => ()})

module Provider = {
  let make = React.Context.provider(context)
}
