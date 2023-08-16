let {context} = module(Constants)

module QRCode = {
  module SVG = {
    @react.component @module("qrcode.react")
    external make: (~value: string, ~size: int=?) => React.element = "default"
  }
}

module RequireVerificationFragment = %relay(`
  fragment RequireVerification_verification on Verification @refetchable(queryName: "VerificationRefetchQuery")
  {
    unique
    contextIds
  }
`)

module BrightIDModal = {
  ReactModal.setAppElement("#root")
  @react.component
  let make = (~contextId, ~verification) => {
    let (verification, refetch) = RequireVerificationFragment.useRefetchable(
      verification->Option.getUnsafe,
    )

    let (isRefetching, startTransition) = ReactExperimental.useTransition()
    let uri = BrightID.SDK.generateDeeplink(~context, ~contextId)

    <ReactModal isOpen={true} onRequestClose={_ => ()} className="z-50">
      <div className="flex flex-col w-full justify-center items-around h-full">
        <h1> {"This feature requires a Verified BrightID"->React.string} </h1>
        <div>
          <QRCode.SVG value={uri} size={200} />
        </div>
        <a href=uri>
          <button
            className="bg-rose-500"
            onClick={_ => {
              startTransition(() => {
                let _ = refetch(
                  ~variables={id: Some(contextId)},
                  ~fetchPolicy=RescriptRelay.NetworkOnly,
                )
              })
            }}>
            {"📱Link "->React.string}
          </button>
        </a>
        <button className="bg-rose-500" onClick={_ => ()}>
          {"Confirm BrightID Link "->React.string}
        </button>
      </div>
    </ReactModal>
  }
}

module RequireVerificationQuery = %relay(`
  query RequireVerificationQuery($contextId: String!) {
    verification(contextId: $contextId) {
      ...RequireVerification_verification
    }
  }
`)

@react.component
let make = () => {
  let requireVerificationContext = React.useContext(RequireVerificationContext.context)
  let {replace} = RelayRouter.Utils.useRouter()
  let contextId =
    Dom.Storage2.localStorage->Dom.Storage2.getItem("contextId")->Option.getWithDefault("0")
  let {verification} = RequireVerificationQuery.use(~variables={contextId: contextId})

  let {queryParams} = Routes.Main.Route.useQueryParams()
  let link = Routes.Main.Route.makeLinkFromQueryParams({...queryParams, brightid: None})

  let isVerified =
    requireVerificationContext.verification->Option.mapWithDefault(false, ({isVerified}) =>
      isVerified
    )

  let _ = isVerified ? replace(link) : ()

  let fragmentRefs = verification->Option.map(verification => verification.fragmentRefs)

  <BrightIDModal contextId verification={fragmentRefs} />
}
