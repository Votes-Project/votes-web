module Query = %relay(`
  query AuctionListQuery {
    ...AuctionListDisplay_auctionCreateds
    ...AuctionListDisplay_auctionSettleds
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef, ~children, ~tokenId) => {
  let data = Query.usePreloaded(~queryRef)

  <>
    <React.Suspense fallback={<div> {React.string("Loading Auctions...")} </div>}>
      <AuctionListDisplay query={data.fragmentRefs} tokenId> {children} </AuctionListDisplay>
    </React.Suspense>
  </>
}