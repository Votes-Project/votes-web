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
  query LinkBrightIDQuery($contextId: String!) {
    verification(contextId: $contextId) {
      ... on VerificationData {
        id
        unique
        contextIds
      }
      ... on BrightIdError {
        error
      }
      ...DailyQuestion_verification
    }
  }
`)

@react.component
let make = (~queryRef, ~contextId) => {
  let {verification} = Query.usePreloaded(~queryRef)

  let (isRefetching, startTransition) = ReactExperimental.useTransition()

  let uri = BrightID.SDK.generateDeeplink(~context, ~contextId)

  let {setParams, queryParams} = Routes.Main.Route.useQueryParams()

  let setLinkBrightID = linkBrightID => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Replace,
      ~shallow=false,
      ~setter=c => {
        ...c,
        linkBrightID,
      },
      ~onAfterParamsSet=_ => {
        startTransition(_ => ())
      },
    )
  }

  React.useEffect1(() => {
    switch verification.unique {
    | None => ()
    | Some(_) => setLinkBrightID(None)
    }
    None
  }, [verification])

  let linkText = linkBrightID =>
    switch (linkBrightID, isRefetching) {
    | (Some(0), _) => "Confirm Link"
    | (Some(1), true) => "Confirming..."
    | (Some(_), true) => "Retrying..."
    | (Some(_), false) => "Failed...Retry?"
    | _ => "Confirm Link"
    }

  <div className="flex flex-col w-full justify-around items-center h-full">
    <div className="w-full text-center">
      <h1 className="text-white text-3xl lg:text-4xl font-bold pt-4">
        {"Scan the QR Code to Link BrightID"->React.string}
      </h1>
    </div>
    <div className=" flex flex-col justify-center items-center bg-black/10 p-4 rounded-xl">
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
    </div>
    <div className="  bg-black/10 p-4 rounded-xl">
      <button
        className="p-4 bg-background-light rounded-lg font-semibold pointer-events-auto "
        onClick={_ =>
          queryParams.linkBrightID->Option.map(linkBrightID => linkBrightID + 1)->setLinkBrightID}>
        {queryParams.linkBrightID->linkText->React.string}
      </button>
    </div>
  </div>
}
