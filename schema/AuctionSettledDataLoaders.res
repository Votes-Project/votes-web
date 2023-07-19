type t = {byId: DataLoader.t<string, option<AuctionSettled.auctionSettled>>}

type data = {auctionSettled: AuctionSettled.auctionSettled}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionSettledDocument"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({auctionSettled}) => auctionSettled)
    }
  }),
}
