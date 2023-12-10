type verification = Verification({id: string, unique: bool}) | Error({error: bool, errorNum: int})
type context = {
  verification: option<verification>,
  setVerification: (option<verification> => option<verification>) => unit,
}

let context = React.createContext({verification: None, setVerification: _ => ()})

module Provider = {
  let make = React.Context.provider(context)
}
