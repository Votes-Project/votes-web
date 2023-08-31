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
        contextId: None,
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
  let verificationContext = React.useContext(VerificationContext.context)

  // let {setVerification} = React.useContext(RequireVerificationContext.context)
  // let (verification, refetch) = RequireVerificationFragment.useRefetchable(
  //   verification->Option.getUnsafe,
  // )
  // let verification = RequireVerificationFragment.use(verification->Option.getUnsafe)

  // let (isRefetching, startTransition) = ReactExperimental.useTransition()

  // let handleConfirmLink = () => {
  //   startTransition(() => {
  //     let _ = refetch(~variables={id: Some(contextId)}, ~fetchPolicy=RescriptRelay.NetworkOnly)
  //     setVerification(_ => Some({
  //       isVerified: verification.unique,
  //       contextId: verification.contextIds[0]->Option.getExn,
  //     }))
  //   })
  // }

  <ReactModal isOpen onRequestClose=onClose> {children} </ReactModal>
}
