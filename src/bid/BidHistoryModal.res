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
        bidHistory: None,
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
        backgroundColor: "rgba(0,0,0,0.7)",
        outline: "none",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        backdropFilter: "blur(10px)",
      },
      content: {
        outline: "none",
      },
    }>
    <div className="fixed top-0 p-4 right-0">
      <button onClick=handleClose className="rounded-full p-2 w-12 h-12 bg-default">
        {"❌"->React.string}
      </button>
    </div>
    <div
      className="flex p-4 w-full lg:w-[40rem] flex-col inset-0 max-h-[50rem]  lg:bg-secondary lg:border-4 border-default-light lg:shadow-xl rounded-xl ">
      {children}
    </div>
  </ReactModal>
}
