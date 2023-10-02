module ConnectButton = {
  type chainStatus = | @as("none") None | @as("icon") Icon | @as("full") Full

  @react.component @module("@rainbow-me/rainbowkit")
  external make: (
    ~className: string=?,
    ~showBalance: bool=?,
    ~chainStatus: chainStatus=?,
  ) => React.element = "ConnectButton"
}
