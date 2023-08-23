type t = {byId: DataLoader.t<string, option<VoteTransfer.voteTransfer>>}

type data = {transfer: VoteTransfer.voteTransfer}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetVoteTransferDocument"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({transfer}) => transfer)
    }
  }),
}
