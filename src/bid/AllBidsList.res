module BidItem = {
  module Fragment = %relay(`
  fragment AllBidsList_BidItem_auctionBid on AuctionBid {
    id
    bidder
    amount
  }
`)
  @react.component
  let make = (~bid) => {
    let {amount, bidder, id} = Fragment.use(bid)
    let amount = amount->Viem.formatUnits(18)
    let isNarrow = window->Window.innerWidth < 640

    <li className="border-b p-3 border-background-dark" key=id>
      <div className=" font-semibold flex items-center justify-between">
        <ShortAddress address={Some(bidder)} avatar={!isNarrow} />
        <div className="flex gap-2">
          <p> {`Ξ ${amount}`->React.string} </p>
          <p> {"🔗"->React.string} </p>
        </div>
      </div>
    </li>
  }
}

module Fragment = %relay(`
  fragment AllBidsList_auction on Auction
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 1000 }
    orderBy: { type: "OrderBy_AuctionBids", defaultValue: blockTimestamp }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    where: { type: "Where_AuctionBids" }
  ) {
    bids(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
      where: $where
    ) @connection(key: "AllBidsList_bids") {
      __id
      edges {
        __id
        node {
          id
          ...AllBidsList_BidItem_auctionBid
        }
      }
    }
  }
  `)
@react.component
let make = (~bids) => {
  let {bids} = Fragment.use(bids)
  <div className="bg-default-light">
    {bids
    ->Fragment.getConnectionNodes
    ->Array.map(({id, fragmentRefs}) => {
      <BidItem key=id bid={fragmentRefs} />
    })
    ->React.array}
  </div>
}
