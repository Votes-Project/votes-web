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
      },
      content: {
        outline: "none",
      },
    }>
    <div className="justify-center items-center flex inset-0 ">
      <div className="relative w-auto mx-auto max-w-3xl">
        <div
          className="flex flex-col border-0 rounded-xl shadow-xl relative w-full bg-secondary justify-start items-center min-w-[740px] max-h-[890px] noise overflow-scroll hide-scrollbar">
          <div className=" w-full px-4 h-full flex flex-col justify-around"> {children} </div>
        </div>
      </div>
    </div>
  </ReactModal>
}
