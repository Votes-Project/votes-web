type auction = {
  tokenId?: string,
  startTime?: string,
  endTime?: string,
  currentBid?: string,
}

type context = {
  todaysAuction: option<auction>,
  setTodaysAuction: (option<auction> => option<auction>) => unit,
}

let context = React.createContext({todaysAuction: None, setTodaysAuction: _ => ()})

module Provider = {
  let make = React.Context.provider(context)
}
