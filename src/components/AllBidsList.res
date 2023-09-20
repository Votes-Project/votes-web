module BidItem = {
  module BidItemFragment = %relay(`
  fragment AllBidsList_BidItem_auctionBid on AuctionBid {
    id
    tokenId
    bidder
    amount
  }
`)
  @react.component
  let make = (~auctionBid as auctionBidRef) => {
    let {amount, bidder, id, tokenId} = BidItemFragment.use(auctionBidRef)
    let amount = amount->BigInt.fromString->Viem.formatUnits(18)

    <li className="border-b p-3 border-background-dark" key=id>
      <div className=" font-semibold flex items-center justify-between">
        <ShortAddress address={Some(bidder)} />
        <div className="flex gap-2">
          <p> {`Ξ ${amount}`->React.string} </p>
          <p> {"🔗"->React.string} </p>
        </div>
      </div>
    </li>
  }
}

module AllBidsListDisplay = {
  module Fragment = %relay(`
  fragment AllBidsListDisplay_auctionBids on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 1000 }
    orderBy: { type: "OrderBy_AuctionBids", defaultValue: tokenId }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    where: { type: "Where_AuctionBids" }
  ) {
    auctionBids(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
      where: $where
    ) @connection(key: "AllBidsListDisplay_auctionBids_auctionBids") {
      __id
      edges {
        __id
        node {
          id
          tokenId
          amount
          ...AllBidsList_BidItem_auctionBid
        }
      }
    }
  }
  `)
  @react.component
  let make = (~query) => {
    let {auctionBids} = Fragment.use(query)
    <div className="bg-background-light">
      {auctionBids
      ->Fragment.getConnectionNodes
      ->Array.map(auctionBid => {
        <BidItem key=auctionBid.id auctionBid={auctionBid.fragmentRefs} />
      })
      ->React.array}
    </div>
  }
}

module Query = %relay(`
  query AllBidsListQuery($where: Where_AuctionBids) {
    ...AllBidsListDisplay_auctionBids @arguments(where: $where)
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)

  <React.Suspense fallback={<div> {React.string("Loading Auction Bids...")} </div>}>
    <ErrorBoundary
      fallback={({error}) => <>
        {`Error! \n ${error->Exn.name->Option.getWithDefault("")}: ${error
          ->Exn.message
          ->Option.getWithDefault(
            "Something went wrong connecting to the votes API",
          )}`->React.string}
      </>}>
      <AllBidsListDisplay query={data.fragmentRefs} />
    </ErrorBoundary>
  </React.Suspense>
}
