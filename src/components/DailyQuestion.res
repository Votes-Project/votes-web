@send
external addEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "addEventListener"
@send
external removeEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "removeEventListener"

ReactModal.setAppElement("#root")
module Modal = {
  @react.component
  let make = (~isOpen, ~onClose as onRequestClose, ~className) => {
    <ReactModal isOpen onRequestClose className>
      <div
        className="justify-center items-center flex overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none">
        <div className="relative w-auto my-6 mx-auto max-w-3xl">
          <div
            className="border-0 rounded-lg shadow-lg relative flex flex-col w-full bg-white outline-none focus:outline-none">
            <div
              className="flex items-start justify-between p-5 border-b border-solid border-slate-200 rounded-t">
              <h3 className="text-3xl font-semibold"> {"Modal Title"->React.string} </h3>
            </div>
          </div>
        </div>
      </div>
    </ReactModal>
  }
}

module Sheet = {
  open ReactModalSheet

  @react.component
  let make = (~isOpen, ~onClose, ~onCloseEnd, ~className) => {
    <Sheet className isOpen onClose onCloseEnd>
      <Sheet.Container>
        <Sheet.Header />
        <Sheet.Content>
          <p> {"Bottom Sheet"->React.string} </p>
        </Sheet.Content>
      </Sheet.Container>
      <Sheet.Backdrop onTap={onClose} />
    </Sheet>
  }
}

@react.component @relay.deferredComponent
let make = () => {
  let {replace} = RelayRouter.Utils.useRouter()
  let {queryParams} = Routes.Main.Route.useQueryParams()
  let (isOpen, setIsOpen) = React.useState(_ => true)

  let onClose = _ => setIsOpen(_ => false)
  let onCloseEnd = _ => Routes.Main.Route.makeLinkFromQueryParams(queryParams)->replace

  React.useEffect0(() => {
    let handleKeyDown = (e: ReactEvent.Keyboard.t) => {
      switch e->ReactEvent.Keyboard.key {
      | "Escape" => Routes.Main.Route.makeLinkFromQueryParams(queryParams)->replace
      | _ => ()
      }
    }
    document->addEventListener(#keydown, handleKeyDown)

    Some(() => document->removeEventListener(#keydown, handleKeyDown))
  })

  <>
    <Sheet className={"lg:hidden flex"} isOpen onClose onCloseEnd />
    <Modal className={`hidden lg:flex`} isOpen onClose />
  </>
}
