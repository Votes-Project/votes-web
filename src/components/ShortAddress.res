@react.component
let make = (~address, ~avatar=None, ~size=24) => {
  let data = Wagmi.useEnsName({
    address: address->Option.getWithDefault(""),
    suspense: true,
    chainId: 1,
  })

  let ensName = data.data

  let shortAddress = AddressAndEnsDisplayUtils.useShortAddress(address)
  // if avatar {
  //   return(
  //     <div className={classes.shortAddress}>
  //       {hasENS &&
  //       avatar &&
  //       <div key={address}>
  //         <Identicon size={size} address={address} provider={provider} />
  //       </div>}
  //       <span> {ens && !ensMatchesBlocklistRegex ? ens : shortAddress} </span>
  //     </div>,
  //   )
  // }
  <>
    {switch (ensName->Nullable.toOption, shortAddress) {
    | (Some(ensName), _) => ensName
    | (None, Some(shortAddress)) => shortAddress
    | (None, None) => "0x0"
    }->React.string}
  </>
}
