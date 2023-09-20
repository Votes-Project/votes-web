open GraphClient

type auctionsArgs<'orderBy, 'where> = {
  first: option<int>,
  orderBy: 'orderBy,
  orderDirection: option<orderDirection>,
  where: 'where,
}

@gql.enum
type orderBy_Auctions =
  | @as("id") ID
  | @as("tokenId") TokenId
  | @as("blockTimestamp") BlockTimestamp
  | @as("amount") AmounAt

@gql.inputObject
type where_Auctions = {
  id?: string,
  tokenId?: string,
}

type t = {
  byId: DataLoader.t<string, option<Auction.auction>>,
  list: DataLoader.t<
    auctionsArgs<option<orderBy_Auctions>, option<where_Auctions>>,
    array<Auction.auction>,
  >,
}

module ById = {
  type data = {auction: Nullable.t<Auction.auction>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionDocument"
  let make = DataLoader.makeSingle(async id =>
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.flatMap(({auction}) => auction->Nullable.toOption)
    }
  )
}

module List = {
  type data = {auctions: array<Auction.auction>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionsDocument"
  let make = DataLoader.makeSingle(async args => {
    switch await GraphClient.executeWithList(
      document,
      {
        first: args.first->Option.getWithDefault(100),
        orderBy: args.orderBy->Option.getWithDefault(ID),
        orderDirection: args.orderDirection->Option.getWithDefault(Asc),
        where: args.where->Option.getWithDefault(({}: where_Auctions)),
      },
    ) {
    | exception _ => []
    | res =>
      res.data->Option.mapWithDefault([], ({auctions}) =>
        auctions->Array.map(auction => (auction :> Auction.auction))
      )
    }
  })
}

let make = () => {
  byId: ById.make,
  list: List.make,
}
