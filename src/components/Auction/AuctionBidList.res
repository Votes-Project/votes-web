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
  let make = (~auctionBid as auctionBidRef, ~isCurrentBid) => {
    let {amount, bidder} = AuctionBidItemFragment.use(auctionBidRef)
    let amount = amount->BigInt.fromString->Viem.formatUnits(18)

    let {setTodaysAuction} = React.useContext(TodaysAuctionContext.context)

    React.useEffect3(() => {
      if isCurrentBid {
        open TodaysAuctionContext
        setTodaysAuction(todaysAuction =>
          todaysAuction->Option.mapWithDefault(
            Some({currentBid: amount}),
            todaysAuction => Some({
              ...todaysAuction,
              currentBid: amount,
            }),
          )
        )
      } else {
        ()
      }
      None
    }, (isCurrentBid, amount, setTodaysAuction))

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
    first: { type: "Int", defaultValue: 1000 }
    orderBy: { type: "OrderBy_AuctionBids", defaultValue: tokenId }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
  ) {
    auctionBids(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
    ) @connection(key: "AuctionBidListDisplay_auctionBids_auctionBids") {
      edges {
        node {
          id
          tokenId
          amount
          ...AuctionBidList_AuctionBidItem_auctionBid
        }
      }
    }
  }
  `)
  @react.component
  let make = (~query) => {
    let {queryParams} = Routes.Main.Auction.Bids.Route.useQueryParams()
    let {todaysAuction} = React.useContext(TodaysAuctionContext.context)
    let tokenId = switch (queryParams.tokenId, todaysAuction) {
    | (Some(tokenId), _) => tokenId
    | (None, Some({tokenId})) => tokenId
    | _ => ""
    }

    let {auctionBids} = AuctionBidsFragment.use(query)
    let groupedBids = Dict.make()

    auctionBids
    ->AuctionBidsFragment.getConnectionNodes
    ->Array.forEach(auctionBid => {
      let bidsByTokenId = groupedBids->Dict.get(auctionBid.tokenId)->Option.getWithDefault(list{})
      groupedBids->Dict.set(auctionBid.tokenId, list{...bidsByTokenId, auctionBid})
    })

    let sortBids = (
      bids: list<AuctionBidListDisplay_auctionBids_graphql.Types.fragment_auctionBids_edges_node>,
    ) =>
      bids->List.sort((a, b) => {
        BigInt.fromString(a.amount) > b.amount->BigInt.fromString ? -1.0 : 1.0
      })

    groupedBids
    ->Dict.get(tokenId)
    ->Option.mapWithDefault(list{}, sortBids)
    ->List.mapWithIndex((i, auctionBid) => {
      i == 0
        ? <AuctionBidItem
            auctionBid={auctionBid.fragmentRefs} key=auctionBid.id isCurrentBid=true
          />
        : <AuctionBidItem
            auctionBid={auctionBid.fragmentRefs} key=auctionBid.id isCurrentBid=false
          />
    })
    ->List.toArray
    ->React.array
  }
}

module Query = %relay(`
  query AuctionBidListQuery {
    ...AuctionBidListDisplay_auctionBids
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)

  <React.Suspense fallback={<div> {React.string("Loading Auction Bids...")} </div>}>
    <AuctionBidListDisplay query={data.fragmentRefs} />
  </React.Suspense>
}
