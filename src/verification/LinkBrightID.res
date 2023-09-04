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

module LinkBrightIDFragment = %relay(`
  fragment LinkBrightID_verification on Verification {
    ... on VerificationData {
      id
      unique
      contextIds
    }
    ... on BrightIdError {
      error
    }
  }
`)

module Query = %relay(`
  query LinkBrightIDQuery($contextId: String!) {
    verification(contextId: $contextId) {
      ...LinkBrightID_verification
      ...DailyQuestion_verification
    }
  }
`)

@react.component
let make = (~queryRef, ~contextId) => {
  let data = Query.usePreloaded(~queryRef)
  let uri = BrightID.SDK.generateDeeplink(~context, ~contextId)
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

  let isVerified = false
  // requireVerificationContext.verification->Option.mapWithDefault(false, ({isVerified}) =>
  //   isVerified
  // )

  <div className="flex flex-col w-full justify-around items-center h-full">
    <button
      onClick={_ => setLinkBrightID(None)} className="absolute text-white text-2xl top-8 right-8">
      {"❌"->React.string}
    </button>
    <div className="w-full text-center">
      <h1 className="text-white text-3xl font-bold py-4">
        {"Scan the QR Code to Link BrightID"->React.string}
      </h1>
    </div>
    <div className="w-full flex flex-col justify-center items-center gap-3">
      <DeviceDetect.BrowserView>
        <QRCode.SVG className="static border-4 border-active rounded-md" value={uri} size={400} />
      </DeviceDetect.BrowserView>
      <DeviceDetect.MobileView>
        <a href=uri>
          <button className="text-3xl py-4 px-2 bg-active rounded-full">
            {"Link Bright ID"->React.string}
          </button>
        </a>
      </DeviceDetect.MobileView>
    </div>
    <button className="p-4 bg-background-light rounded-lg font-semibold" onClick={_ => ()}>
      {"Check BrightID Status"->React.string}
    </button>
  </div>
}
