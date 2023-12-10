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
    className="flex flex-col pointer-events-auto  justify-center items-center outline-none"
    overlayClassName="fixed backdrop-blur-sm bg-black/70 h-[100svh] outline-none inset-0 flex justify-center items-center"
    isOpen
    onRequestClose=onClose>
    <div className="fixed flex items-center justify-center top-2 p-2 lg:pt-4 lg:pr-4 right-4">
      <button
        onClick=onClose
        className="rounded-full w-full h-full lg:p-2 text-4xl text-center lg:bg-default text-white font-bold lg:text-default-darker">
        <ReactIcons.LuX />
      </button>
    </div>
    <div
      className="flex p-2 lg:p-4 w-screen lg:w-[40rem] max-w-2xl flex-col inset-0 max-h-[80vh] lg:max-h-[50rem] lg:bg-default-light lg:shadow-xl rounded-xl justify-center lg:justify-start">
      {children}
    </div>
  </ReactModal>
}
