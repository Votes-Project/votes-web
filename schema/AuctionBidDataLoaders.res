type t = {byId: DataLoader.t<string, option<AuctionBid.auctionBid>>}

type data = {auctionBid: AuctionBid.auctionBid}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionBidDocument"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({auctionBid}) => auctionBid)
    }
  }),
}
