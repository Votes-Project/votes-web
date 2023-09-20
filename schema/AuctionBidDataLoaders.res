open GraphClient
type auctionBidsArgs<'orderBy, 'where> = {
  first: option<int>,
  orderBy: 'orderBy,
  orderDirection: option<orderDirection>,
  where: 'where,
}

@gql.enum
type orderBy_AuctionBids =
  | @as("id") ID
  | @as("tokenId") TokenId
  | @as("blockTimestamp") BlockTimestamp
  | @as("amount") Amount

@gql.inputObject
type where_AuctionBids = {
  id?: string,
  tokenId?: string,
}

type t = {
  byId: DataLoader.t<string, option<AuctionBid.auctionBid>>,
  list: DataLoader.t<
    auctionBidsArgs<option<orderBy_AuctionBids>, option<where_AuctionBids>>,
    array<AuctionBid.auctionBid>,
  >,
}

type data = {auctionBid: AuctionBid.auctionBid}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionBidDocument"
module ById = {
  type data = {auctionBid: Nullable.t<AuctionBid.auctionBid>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionBidDocument"
  let make = DataLoader.makeSingle(async id =>
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.flatMap(({auctionBid}) => auctionBid->Nullable.toOption)
    }
  )
}

module List = {
  type data = {auctionBids: array<AuctionBid.auctionBid>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionBidsDocument"
  let make = DataLoader.makeSingle(async args => {
    switch await GraphClient.executeWithList(
      document,
      {
        first: args.first->Option.getWithDefault(100),
        orderBy: args.orderBy->Option.getWithDefault(ID),
        orderDirection: args.orderDirection->Option.getWithDefault(Asc),
        where: args.where->Option.getWithDefault(({}: where_AuctionBids)),
      },
    ) {
    | exception _ => []
    | res =>
      res.data->Option.mapWithDefault([], ({auctionBids}) =>
        auctionBids->Array.map(auctionBid => (auctionBid :> AuctionBid.auctionBid))
      )
    }
  })
}
let make = () => {
  byId: ById.make,
  list: List.make,
}
