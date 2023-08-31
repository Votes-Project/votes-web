type verification = {isVerified: bool, contextId: Uint8Array.t}

type context = {
  verification: option<verification>,
  setVerification: (option<verification> => option<verification>) => unit,
}

let context = React.createContext({verification: None, setVerification: _ => ()})

module Provider = {
  let make = React.Context.provider(context)
}
