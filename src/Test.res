module Query = %relay(`
  query TestQuery {
    auctionSettleds {
      edges {
        node {
          id
          tokenId
          }
      }
    }
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)
  Js.log2("data: ", data)
  <div> {React.string("Test")} </div>
}
