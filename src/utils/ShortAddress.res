module Davatar = {
  type avatarType = | @as("jazzicon") Jazzicon | @as("blockies") Blockies
  @react.component @module("@davatar/react")
  external make: (
    ~size: int,
    ~address: string,
    ~provider: 'provider=?,
    ~graphApiKey: string=?,
    ~generatedAvatarType: avatarType=?,
  ) => React.element = "default"
}

@react.component
let make = (~address, ~avatar=?, ~size=24) => {
  open Wagmi
  // let provider = PublicClient.use()
  let {data: ensName} = ENS.Name.use({
    address: address->Option.getWithDefault(""),
    suspense: true,
    chainId: 1,
  })

  let shortAddress =
    AddressAndEnsDisplayUtils.useShortAddress(address)->Option.getWithDefault("0x0")

  switch avatar {
  | Some(true) =>
    <div className="flex flex-row flex-nowrap gap-2 items-center">
      <div>
        <Davatar
          size={size}
          address={address->Option.getWithDefault("")}
          // provider={provider}
          generatedAvatarType=Jazzicon
        />
      </div>
      <span> {ensName->Nullable.toOption->Option.getWithDefault(shortAddress)->React.string} </span>
    </div>
  | _ => ensName->Nullable.toOption->Option.getWithDefault(shortAddress)->React.string
  }
}
