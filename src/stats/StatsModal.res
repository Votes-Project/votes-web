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

  let setStats = stats => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        stats,
      },
    )
  }

  let onClose = _ => setStats(None)

  React.useEffect0(() => {
    let handleKeyDown = (e: ReactEvent.Keyboard.t) => {
      switch e->ReactEvent.Keyboard.key {
      | "Escape" => setStats(None)
      | _ => ()
      }
    }
    document->addEventListener(#keydown, handleKeyDown)

    Some(() => document->removeEventListener(#keydown, handleKeyDown))
  })

  <ReactModal
    style={
      overlay: {
        backgroundColor: "transparent",
        backdropFilter: "blur(4px)",
        outline: "none",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        zIndex: "0",
        boxShadow: "var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow)",
      },
      content: {
        outline: "none",
        pointerEvents: "none",
      },
    }
    className="w-full h-screen max-w-3xl flex justify-center items-center"
    isOpen
    onRequestClose=onClose>
    <FramerMotion.AnimatePresence initial=false>
      <FramerMotion.Div
        layout=True
        layoutId="stats"
        className="pointer-events-auto bg-white w-5/6 h-1/2 shadow-2xl rounded-2xl ">
        {children}
      </FramerMotion.Div>
    </FramerMotion.AnimatePresence>
  </ReactModal>
}
