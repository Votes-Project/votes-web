module Query = %relay(`
  query AuctionListQuery {
    ...AuctionListDisplay_auctionCreateds
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef, ~tokenId) => {
  let data = Query.usePreloaded(~queryRef)

  <>
    <React.Suspense fallback={<div> {React.string("Loading Auctions...")} </div>}>
      <AuctionListDisplay query={data.fragmentRefs} tokenId />
    </React.Suspense>
  </>
}
