@react.component
let make = () => {
  let {address} = Wagmi.Account.use()
  let address = address->Nullable.toOption->Option.getWithDefault("0x0")
  let sortByOptions = [("newest", "Newest"), ("oldest", "Oldest"), (address, "Owned")]

  sortByOptions
  ->Array.map(((value, text)) => {
    <option key=value value> {text->React.string} </option>
  })
  ->React.array
}
