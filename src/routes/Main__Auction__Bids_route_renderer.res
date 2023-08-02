module AuctionBidList = %relay.deferredComponent(AuctionBidList.make)

let renderer = Routes.Main.Auction.Bids.Route.makeRenderer(
  ~prepare=({environment, tokenId}) => {
    let tokenId = tokenId->Option.getWithDefault("")
    AuctionBidListQuery_graphql.load(
      ~environment,
      ~fetchPolicy=StoreOrNetwork,
      ~variables={where: {tokenId: tokenId}},
    )
  },
  ~render=({prepared}) => {
    <AuctionBidList queryRef=prepared />
  },
)
