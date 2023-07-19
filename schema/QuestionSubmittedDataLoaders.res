type t = {byId: DataLoader.t<string, option<QuestionSubmitted.questionSubmitted>>}

type data = {
  auctionSettled: AuctionSettled.auctionSettled,
  questionSubmitted: QuestionSubmitted.questionSubmitted,
}

@module("../.graphclient/index.js") @val
external document: GraphClient.document<GraphClient.result<data>> = "GetQuestionSubmittedDocument"

let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({questionSubmitted}) => questionSubmitted)
    }
  }),
}
