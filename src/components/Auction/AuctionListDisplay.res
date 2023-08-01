module AuctionCreatedsFragment = %relay(`
  fragment AuctionListDisplay_auctionCreateds on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 6 }
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
let make = (~query, ~tokenId) => {
  let {auctionCreateds} = AuctionCreatedsFragment.use(query)

  let {auctionSettleds} = AuctionSettledsFragment.use(query)

  let todaysAuctionFragment =
    auctionCreateds->AuctionCreatedsFragment.getConnectionNodes->Array.shift
  let auctionFragments = Belt.Array.zip(
    auctionCreateds
    ->AuctionCreatedsFragment.getConnectionNodes
    ->Array.toSpliced(~start=0, ~remove=1, ~insert=[]), // Note: Wouldn't have to do this splice if lists are in ascending order
    auctionSettleds->AuctionSettledsFragment.getConnectionNodes,
  )

  let isToday =
    todaysAuctionFragment
    ->Option.map(({tokenId}) => tokenId)
    ->Option.equal(tokenId, (a, b) => a == b)

  let auctionItems = switch tokenId {
  | None =>
    todaysAuctionFragment->Option.map(auctionCreated => [
      <AuctionItem
        auctionCreated={auctionCreated.fragmentRefs} key=auctionCreated.id isToday=true
      />,
    ])
  | Some(tokenId) =>
    if isToday {
      todaysAuctionFragment->Option.map(auctionCreated => [
        <AuctionItem
          auctionCreated={auctionCreated.fragmentRefs} key=auctionCreated.id isToday=true
        />,
      ])
    } else {
      auctionFragments
      ->Array.filter(((auctionCreated, _)) => tokenId == auctionCreated.tokenId)
      ->Array.map(((auctionCreated, auctionSettled)) => {
        <AuctionItem
          auctionCreated={auctionCreated.fragmentRefs}
          auctionSettled={Some(auctionSettled.fragmentRefs)}
          key=auctionCreated.id
        />
      })
      ->Some
    }
  }

  auctionItems->Option.getExn->React.array
}
