type t = {byId: DataLoader.t<string, option<Vote.vote>>}

type data = {vote: Vote.vote}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetVoteDocument"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({vote}) => vote)
    }
  }),
}
