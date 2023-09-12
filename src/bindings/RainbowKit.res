module ConnectButton = {
  @react.component @module("@rainbow-me/rainbowkit")
  external make: (~className: string=?, ~showBalance: bool=?) => React.element = "ConnectButton"
}
