type t = {byId: DataLoader.t<string, option<VoteContract.voteContract>>}

type data = {voteContract: VoteContract.voteContract}
@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetVoteContractDocument"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({voteContract}) => voteContract)
    }
  }),
}
