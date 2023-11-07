@react.component
let make = (~children) => {
  let {address} = Wagmi.Account.use()
  let {openConnectModal} = RainbowKit.useConnectModal()

  let handleClick = e => {
    switch address->Nullable.toOption {
    | None =>
      e->ReactEvent.Mouse.stopPropagation
      openConnectModal()
    | Some(_) => ()
    }
  }

  <div onClick=handleClick> {children} </div>
}
