let {context} = module(Constants)

module QRCode = {
  module SVG = {
    @react.component @module("qrcode.react")
    external make: (~className: string, ~value: string, ~size: int=?) => React.element = "default"
  }
}

module DeviceDetect = {
  @module("react-device-detect") external isMobile: bool = "isMobile"
  module BrowserView = {
    @react.component @module("react-device-detect")
    external make: (~children: React.element) => React.element = "BrowserView"
  }
  module MobileView = {
    @react.component @module("react-device-detect")
    external make: (~children: React.element) => React.element = "MobileView"
  }
}

module Query = %relay(`
  query LinkBrightIDQuery($contextId: ID!) {
    userById(id: $contextId) {
      id
      linked
      verified
    }
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef, ~contextId) => {
  let {userById} = Query.usePreloaded(~queryRef)

  let {setVerification} = React.useContext(VerificationContext.context)

  let (isRefetching, startTransition) = ReactExperimental.useTransition()

  let uri = BrightID.SDK.generateDeeplink(~context, ~contextId)

  let {setParams, queryParams} = Routes.Main.Route.useQueryParams()

  let {setAlerts} = React.useContext(StatsAlertContext.context)

  let setLinkBrightID = (linkBrightID, ~verification=?) => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Replace,
      ~shallow=false,
      ~setter=c => {
        ...c,
        linkBrightID,
      },
      ~onAfterParamsSet=_ => {
        startTransition(() => {
          setAlerts(alerts => alerts->Array.filter(a => a !== LinkBrightID))
          setVerification(_ => verification)
        })
      },
    )
  }

  React.useEffect1(() => {
    open VerificationContext
    switch userById {
    | Some({id, verified}) =>
      setLinkBrightID(None, ~verification=Verification({id, unique: verified}))
    | _ => ()
    }
    None
  }, [userById])

  let linkText = linkBrightID =>
    switch (linkBrightID, isRefetching) {
    | (Some(0), _) => "Confirm Link"
    | (Some(1), true) => "Confirming..."
    | (Some(_), true) => "Retrying..."
    | (Some(_), false) => "Failed...Retry?"
    | _ => "Confirm Link"
    }

  <div className="flex flex-col w-full justify-around items-center h-full z-50 ">
    <div className="w-full text-center">
      <p className="text-white text-3xl lg:text-4xl font-bold py-4">
        {"Scan the QR Code to Link BrightID"->React.string}
      </p>
      <p className="text-white text-3xl lg:text-4xl font-bold py-4">
        {"This should say smething about BrightID to help useres link."->React.string}
      </p>
    </div>
    <div
      className=" pointer-events-auto flex flex-col justify-center items-center bg-black/10 p-4 rounded-xl">
      <DeviceDetect.BrowserView>
        <QRCode.SVG className="static border-4 border-active rounded-md" value={uri} size={400} />
      </DeviceDetect.BrowserView>
      <DeviceDetect.MobileView>
        <a
          href=uri
          className="pointer-events-auto appearance-button text-3xl p-4 text-white bg-active rounded-full font-bold">
          {"Link BrightID"->React.string}
        </a>
      </DeviceDetect.MobileView>
      <div className="pt-10 rounded-xl">
        <button
          className="p-4 bg-default-light rounded-lg font-semibold pointer-events-auto "
          onClick={_ =>
            queryParams.linkBrightID
            ->Option.map(linkBrightID => linkBrightID + 1)
            ->setLinkBrightID}>
          {queryParams.linkBrightID->linkText->React.string}
        </button>
      </div>
    </div>
  </div>
}
