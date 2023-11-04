module Davatar = {
  type avatarType = | @as("jazzicon") Jazzicon | @as("blockies") Blockies
  module Image = {
    @react.component @module("@davatar/react")
    external make: (
      ~size: int,
      ~address: string,
      ~provider: 'provider=?,
      ~uri: Nullable.t<string>=?,
      ~graphApiKey: string=?,
      ~generatedAvatarType: avatarType=?,
    ) => React.element = "Image"
  }
}

@react.component
let make = (~address, ~avatar=?, ~size=24) => {
  open Wagmi

  let provider = PublicClient.use()
  let {data: ensName} = ENS.Name.use({
    address,
    suspense: true,
    chainId: 1,
  })

  let {data: ensAvatar} = ENS.Avatar.use({
    name: ensName->Nullable.toOption,
    suspense: true,
    chainId: 1,
  })

  let shortAddress =
    AddressAndEnsDisplayUtils.useShortAddress(address)->Option.getWithDefault("0x0")

  switch avatar {
  | Some(true) =>
    <div className="flex flex-row flex-nowrap gap-2 items-center">
      {switch address {
      | Some(address) =>
        <div>
          <Davatar.Image size address provider uri=ensAvatar generatedAvatarType=Jazzicon />
        </div>
      | _ => React.null
      }}
      <span> {ensName->Nullable.toOption->Option.getWithDefault(shortAddress)->React.string} </span>
    </div>
  | _ => ensName->Nullable.toOption->Option.getWithDefault(shortAddress)->React.string
  }
}
