type t = {byId: DataLoader.t<string, option<AuctionContract.auctionContract>>}

type data = {auctionContract: AuctionContract.auctionContract}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionContractDocument"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({auctionContract}) => auctionContract)
    }
  }),
}
