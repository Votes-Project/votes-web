module QueryFragment = %relay(`
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
    ) @connection(key: "Auction_auctionCreateds_auctionCreateds") {
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

@react.component
let make = (~query, ~tokenId) => {
  let {auctionCreateds} = QueryFragment.use(query)
  let auctionItems = switch tokenId {
  | None =>
    auctionCreateds
    ->QueryFragment.getConnectionNodes
    ->Array.get(0)
    ->Option.map(auctionCreated => [
      <AuctionItem auctionCreated={auctionCreated.fragmentRefs} key=auctionCreated.id index=0 />,
    ])
  | Some(tokenId) =>
    auctionCreateds
    ->QueryFragment.getConnectionNodes
    ->Array.filter(auctionCreated => tokenId == auctionCreated.tokenId)
    ->Array.mapWithIndex((auctionCreated, i) => {
      <AuctionItem auctionCreated={auctionCreated.fragmentRefs} key=auctionCreated.id index=i />
    })
    ->Some
  }

  auctionItems->Option.getExn->React.array
}
