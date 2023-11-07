module ConnectButton = {
  type chainStatus = | @as("none") None | @as("icon") Icon | @as("full") Full

  @react.component @module("@rainbow-me/rainbowkit")
  external make: (
    ~className: string=?,
    ~showBalance: bool=?,
    ~chainStatus: chainStatus=?,
  ) => React.element = "ConnectButton"
}

type useConnectModal = {openConnectModal: unit => unit}
type useAccountModal = {openAccountModal: unit => unit}

@module("@rainbow-me/rainbowkit")
external useConnectModal: unit => useConnectModal = "useConnectModal"
@module("@rainbow-me/rainbowkit")
external useAccountModal: unit => useAccountModal = "useAccountModal"
