module QueryFragment = %relay(`
  fragment Auction_auctionCreateds on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 5}
    orderBy: { type: "OrderBy_AuctionCreateds", defaultValue: tokenId}
    orderDirection: { type: "OrderDirection", defaultValue: desc}
  )
  {
    auctionCreateds(orderBy: $orderBy, orderDirection: $orderDirection, first:$first) @connection(key: "Auction_auctionCreateds_auctionCreateds")
    {
      edges {
        node {
          id
           ...AuctionItem_auctionCreated
        }
      }
    }
  }
  `)

@react.component
let make = (~query) => {
  let {auctionCreateds} = QueryFragment.use(query)
  <div className="!self-start p-4">
    {auctionCreateds
    ->QueryFragment.getConnectionNodes
    ->Array.map(auctionCreated =>
      <AuctionItem auctionCreated={auctionCreated.fragmentRefs} key=auctionCreated.id />
    )
    ->React.array}
  </div>
}
