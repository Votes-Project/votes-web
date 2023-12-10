@send
external addEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "addEventListener"
@send
external removeEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "removeEventListener"
@send
external querySelector: (Dom.document, string) => unit = "querySelector"

ReactModal.setAppElement("#root")
@react.component
let make = (~children, ~isOpen) => {
  let {setParams} = Routes.Main.Vote.Auction.Route.useQueryParams()

  let handleClose = _ => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        showAllBids: None,
      },
    )
  }

  React.useEffect0(() => {
    let handleKeyDown = (e: ReactEvent.Keyboard.t) => {
      switch e->ReactEvent.Keyboard.key {
      | "Escape" => handleClose()
      | _ => ()
      }
    }
    document->addEventListener(#keydown, handleKeyDown)

    Some(() => document->removeEventListener(#keydown, handleKeyDown))
  })

  <ReactModal
    isOpen
    onRequestClose={handleClose}
    className="flex pointer-events-auto"
    style={
      overlay: {
        backgroundColor: "rgba(0,0,0,0.5)",
        outline: "none",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        backdropFilter: "blur(2px)",
      },
      content: {
        outline: "none",
      },
    }>
    <div
      className="flex p-4 w-[40rem] flex-col inset-0 max-h-[50rem]  bg-secondary border-4 border-default-light shadow-xl rounded-xl ">
      {children}
    </div>
  </ReactModal>
}
