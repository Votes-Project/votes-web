@send
external addEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "addEventListener"
@send
external removeEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "removeEventListener"

@send
external querySelector: (Dom.document, string) => unit = "querySelector"

let {context} = module(Constants)

ReactModal.setAppElement("#root")
@react.component
let make = (~children, ~isOpen) => {
  let {setParams} = Routes.Main.Route.useQueryParams()

  let setLinkBrightID = linkBrightID => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        linkBrightID,
      },
    )
  }

  let onClose = _ => setLinkBrightID(None)

  React.useEffect0(() => {
    let handleKeyDown = (e: ReactEvent.Keyboard.t) => {
      switch e->ReactEvent.Keyboard.key {
      | "Escape" => setLinkBrightID(None)
      | _ => ()
      }
    }
    document->addEventListener(#keydown, handleKeyDown)

    Some(() => document->removeEventListener(#keydown, handleKeyDown))
  })

  <ReactModal
    style={
      overlay: {
        backgroundColor: "rgba(0,0,0,0.6)",
        backdropFilter: "blur(10px)",
        outline: "none",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
      },
      content: {
        outline: "none",
        pointerEvents: "none",
      },
    }
    className="w-full h-screen pointer-events-auto max-w-3xl"
    isOpen
    onRequestClose=onClose>
    {children}
  </ReactModal>
}
