type t = {byId: DataLoader.t<string, option<Auction.auction>>}

type data = {auction: Auction.auction}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionDocument"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({auction}) => auction)
    }
  }),
}
