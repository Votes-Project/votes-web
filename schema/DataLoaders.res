type t = {
  auctionSettled: AuctionSettledDataLoaders.t,
  questionSubmitted: QuestionSubmittedDataLoaders.t,
}

let make = () => {
  auctionSettled: AuctionSettledDataLoaders.make(),
  questionSubmitted: QuestionSubmittedDataLoaders.make(),
}
