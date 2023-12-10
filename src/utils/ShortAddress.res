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

module ENS = {
  @react.component
  let make = (~address, ~avatar, ~size=24) => {
    open Wagmi

    let provider = PublicClient.use()
    let {data: ensName} = ENS.Name.use({
      address,
      chainId: 1,
    })
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

    let ensAvatar = switch ensAvatar->Nullable.toOption {
    | Some(ensAvatar) => Nullable.make(ensAvatar)
    | None => Nullable.null
    }
    avatar
      ? <div className="flex flex-row flex-nowrap gap-2 items-center">
          <Davatar.Image
            size
            address={address->Option.getExn}
            provider
            uri={ensAvatar}
            generatedAvatarType=Jazzicon
          />
          <span> {ensName->Nullable.getExn->React.string} </span>
        </div>
      : ensName->Nullable.getExn->React.string
  }
}

module Fallback = {
  @react.component
  let make = (~address, ~avatar, ~size=24) => {
    let provider = Wagmi.PublicClient.use()
    let shortAddress =
      address->AddressAndEnsDisplayUtils.useShortAddress->Option.getWithDefault("???")

    avatar
      ? <div className="flex flex-row flex-nowrap gap-2 items-center">
          <Davatar.Image
            size address={address->Option.getExn} provider uri={null} generatedAvatarType=Jazzicon
          />
          <span> {shortAddress->React.string} </span>
        </div>
      : shortAddress->React.string
  }
}

@react.component
let make = (~address, ~avatar=false, ~size=24) =>
  <ErrorBoundary fallback={_ => <Fallback address avatar size />}>
    <React.Suspense fallback={<Fallback address avatar size />}>
      <ENS address avatar size />
    </React.Suspense>
  </ErrorBoundary>
