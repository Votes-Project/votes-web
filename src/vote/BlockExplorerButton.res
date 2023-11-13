module Fragment = %relay(`
  fragment BlockExplorerButton_vote on Vote {
    id
    tokenId
    contract {
      id
      address
    }
  }
  `)

@react.component
let make = (~vote) => {
  let {tokenId, contract} = Fragment.use(vote)
  let {chain} = Wagmi.Network.use()
  let chainBlockExplorer = switch chain->Nullable.toOption {
  | None => None
  | Some({blockExplorers}) => blockExplorers->Dict.get("default")
  }
  switch chainBlockExplorer {
  | Some({name, url}) =>
    <a
      href={url ++ `/token/${contract.address}?a=${tokenId->BigInt.toString}`}
      target="_blank"
      rel="noopener noreferrer">
      <button
        className=" lg:bg-primary font-semibold text-default-darker hover:bg-default-light p-2 bg-default rounded-md transition-colors">
        {name->React.string}
      </button>
    </a>
  | None => <> </>
  }
}
