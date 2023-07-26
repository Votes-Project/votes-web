type t = {byId: DataLoader.t<string, option<AuctionCreated.auctionCreated>>}

type data = {auctionCreated: AuctionCreated.auctionCreated}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionCreatedDocument"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({auctionCreated}) => auctionCreated)
    }
  }),
}
