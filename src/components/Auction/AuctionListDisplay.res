module AuctionCreatedsFragment = %relay(`
  fragment AuctionListDisplay_auctionCreateds on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 5 }
    orderBy: { type: "OrderBy_AuctionCreateds", defaultValue: tokenId }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
  ) {
    auctionCreateds(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
    ) @connection(key: "AuctionListDisplay_auctionCreateds_auctionCreateds") {
      edges {
        node {
          id
          tokenId
          endTime
          ...AuctionItem_auctionCreated
        }
      }
    }
  }
  `)
module AuctionSettledsFragment = %relay(`
  fragment AuctionListDisplay_auctionSettleds on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 5 }
    orderBy: { type: "OrderBy_AuctionSettleds", defaultValue: tokenId }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
  ) {
    auctionSettleds(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
    ) @connection(key: "AuctionListDisplay_auctionSettleds_auctionSettleds") {
      edges {
        node {
          id
          tokenId
          ...AuctionItem_auctionSettled
        }
      }
    }
  }
  `)

@react.component
let make = (~query, ~children, ~tokenId) => {
  let {auctionCreateds} = AuctionCreatedsFragment.use(query)

  let {auctionSettleds} = AuctionSettledsFragment.use(query)

  let isTodaySettled = {
    let latestAuctionTokenId =
      auctionCreateds
      ->AuctionCreatedsFragment.getConnectionNodes
      ->Array.get(0)
      ->Option.map(({tokenId}) => tokenId)
    let latestSettledAuctionTokenId =
      auctionSettleds
      ->AuctionSettledsFragment.getConnectionNodes
      ->Array.get(0)
      ->Option.map(({tokenId}) => tokenId)

    latestAuctionTokenId->Option.equal(latestSettledAuctionTokenId, (a, b) => a == b)
  }

  let (todaysAuctionCreatedFragment, todaysAuctionSettledFragment) = isTodaySettled
    ? (
        auctionCreateds->AuctionCreatedsFragment.getConnectionNodes->Array.get(0),
        auctionSettleds->AuctionSettledsFragment.getConnectionNodes->Array.get(0),
      )
    : (auctionCreateds->AuctionCreatedsFragment.getConnectionNodes->Array.get(0), None)

  let auctionFragments = {
    let auctionCreatedNodes = isTodaySettled
      ? auctionCreateds->AuctionCreatedsFragment.getConnectionNodes
      : auctionCreateds->AuctionCreatedsFragment.getConnectionNodes->Array.sliceToEnd(~start=1)
    Belt.Array.zip(auctionCreatedNodes, auctionSettleds->AuctionSettledsFragment.getConnectionNodes)
  }

  let handleTodaysAuction = (
    auctionCreatedFragment: option<
      AuctionListDisplay_auctionCreateds_graphql.Types.fragment_auctionCreateds_edges_node,
    >,
    auctionSettledFragment: option<
      AuctionListDisplay_auctionSettleds_graphql.Types.fragment_auctionSettleds_edges_node,
    >,
  ) =>
    switch (auctionCreatedFragment, auctionSettledFragment) {
    | (Some(auctionCreated), Some(auctionSettled)) =>
      <AuctionItem
        auctionCreated={auctionCreated.fragmentRefs}
        auctionSettled={auctionSettled.fragmentRefs->Some}
        key=auctionCreated.id
        isToday=true>
        {children}
      </AuctionItem>
    | (Some(auctionCreated), None) =>
      <AuctionItem auctionCreated={auctionCreated.fragmentRefs} key=auctionCreated.id isToday=true>
        {children}
      </AuctionItem>
    | _ => <div> {"There are no auctions today"->React.string} </div>
    }

  let auctionItems = switch tokenId {
  | None => handleTodaysAuction(todaysAuctionCreatedFragment, todaysAuctionSettledFragment)
  | Some(tokenId) =>
    if (
      todaysAuctionCreatedFragment
      ->Option.map(todaysAuction => tokenId == todaysAuction.tokenId)
      ->Option.equal(Some(true), (a, b) => a == b)
    ) {
      handleTodaysAuction(todaysAuctionCreatedFragment, todaysAuctionSettledFragment)
    } else {
      auctionFragments
      ->Array.filter(((auctionCreated, _)) => tokenId == auctionCreated.tokenId)
      ->Array.map(((auctionCreated, auctionSettled)) => {
        <AuctionItem
          auctionCreated={auctionCreated.fragmentRefs}
          auctionSettled={Some(auctionSettled.fragmentRefs)}
          key=auctionCreated.id>
          {children}
        </AuctionItem>
      })
      ->React.array
    }
  }

  auctionItems
}
