module AuctionBidList = %relay.deferredComponent(AuctionBidList.make)

let renderer = Routes.Main.Auction.Bids.Route.makeRenderer(
  ~prepare=({environment}) => {
    AuctionBidListQuery_graphql.load(~environment, ~fetchPolicy=StoreOrNetwork, ~variables=())
  },
  ~render=({prepared}) => {
    <AuctionBidList queryRef=prepared />
  },
)
