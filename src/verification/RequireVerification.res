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
  let make = (
    ~contextId,
    ~refetch: option<
      (
        ~variables: VerificationRefetchQuery_graphql.Types.refetchVariables,
        ~fetchPolicy: RescriptRelay.fetchPolicy=?,
        ~onComplete: option<Js.Exn.t> => unit=?,
      ) => RescriptRelay.Disposable.t,
    >,
  ) => {
    let (isRefetching, startTransition) = ReactExperimental.useTransition()
    let uri = BrightID.SDK.generateDeeplink(~context, ~contextId)

    <ReactModal isOpen={true} onRequestClose={_ => ()}>
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
                let _ =
                  refetch->Option.map(refetch =>
                    refetch(
                      ~variables={id: Some(contextId)},
                      ~fetchPolicy=RescriptRelay.NetworkOnly,
                    )
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

@react.component
let make = (~children, ~queryRef as verificationRef, ~contextId) => {
  let verificationRefetchable =
    verificationRef->Option.map(verificationRef =>
      RequireVerificationFragment.useRefetchable(verificationRef)
    )
  let refetch = verificationRefetchable->Option.map(((_, refetch)) => refetch)
  let isVerified = false

  if isVerified {
    <> {children} </>
  } else {
    <BrightIDModal contextId refetch />
  }
}
