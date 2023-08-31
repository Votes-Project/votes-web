let {context} = module(Constants)

module QRCode = {
  module SVG = {
    @react.component @module("qrcode.react")
    external make: (~value: string, ~size: int=?) => React.element = "default"
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
  let uri = BrightID.SDK.generateDeeplink(~context, ~contextId=TypedArray.toString(contextId))

  let {replace} = RelayRouter.Utils.useRouter()

  let isVerified = false
  // requireVerificationContext.verification->Option.mapWithDefault(false, ({isVerified}) =>
  //   isVerified
  // )

  <div className="flex flex-col w-full justify-center items-around h-full">
    <h1> {"This feature requires a Verified BrightID"->React.string} </h1>
    <div>
      <QRCode.SVG value={uri} size={200} />
    </div>
    <a href=uri>
      <button className="bg-rose-500"> {"📱Link "->React.string} </button>
    </a>
    <button className="bg-rose-500" onClick={_ => ()}>
      {"Confirm BrightID Link "->React.string}
    </button>
  </div>
}
