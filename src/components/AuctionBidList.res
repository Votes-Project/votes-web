module AuctionBidItem = {
  module AuctionBidItemFragment = %relay(`
  fragment AuctionBidList_AuctionBidItem_auctionBid on AuctionBid {
    id
    tokenId
    bidder
    amount
  }
`)
  @react.component
  let make = (~auctionBid as auctionBidRef) => {
    let {amount, bidder} = AuctionBidItemFragment.use(auctionBidRef)
    let amount = amount->BigInt.fromString->Viem.formatUnits(18)
    <>
      <div className="flex items-center justify-between">
        <ShortAddress address={Some(bidder)} />
        <div className="flex gap-2">
          <p> {`${amount} Ξ`->React.string} </p>
          <p> {"🔗"->React.string} </p>
        </div>
      </div>
      <div className="my-3 h-0 w-full border border-black" />
    </>
  }
}

module AuctionBidListDisplay = {
  module AuctionBidsFragment = %relay(`
  fragment AuctionBidListDisplay_auctionBids on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 5 }
    orderBy: { type: "OrderBy_AuctionBids", defaultValue: blockTimestamp }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    where: { type: "Where_AuctionBids"}
  ) {
    auctionBids(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
      where: $where
    ) @connection(key: "AuctionBidListDisplay_auctionBids_auctionBids") {
      edges {
        node {
          id
          tokenId
          ...AuctionBidList_AuctionBidItem_auctionBid
        }
      }
    }
  }
  `)
  @react.component
  let make = (~query) => {
    let {auctionBids} = AuctionBidsFragment.use(query)

    auctionBids
    ->AuctionBidsFragment.getConnectionNodes
    ->Array.map(auctionBid => {
      <AuctionBidItem auctionBid={auctionBid.fragmentRefs} key=auctionBid.id />
    })
    ->React.array
  }
}

module Query = %relay(`
  query AuctionBidListQuery($where: Where_AuctionBids) {
    ...AuctionBidListDisplay_auctionBids @arguments(where: $where)
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)

  <React.Suspense fallback={<div> {React.string("Loading Auction Bids...")} </div>}>
    <AuctionBidListDisplay query={data.fragmentRefs} />
  </React.Suspense>
}
