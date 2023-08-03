module AuctionList = %relay.deferredComponent(AuctionList.make)

let renderer = Routes.Main.Auction.Route.makeRenderer(
  ~prepare=({environment}) => {
    AuctionListQuery_graphql.load(~environment, ~fetchPolicy=StoreOrNetwork, ~variables=())
  },
  ~render=({prepared, tokenId, childRoutes}) => {
    <AuctionList queryRef=prepared tokenId> {childRoutes} </AuctionList>
  },
)