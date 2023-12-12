type alert = LinkBrightID

type context = {
  alerts: array<alert>,
  setAlerts: (array<alert> => array<alert>) => unit,
}

let context = React.createContext({
  alerts: [],
  setAlerts: _ => (),
})

module Provider = {
  let make = React.Context.provider(context)
}
