type t = {
  auctionSettled: AuctionSettledDataLoaders.t,
  auctionCreated: AuctionCreatedDataLoaders.t,
  questionSubmitted: QuestionSubmittedDataLoaders.t,
}

let make = () => {
  auctionSettled: AuctionSettledDataLoaders.make(),
  auctionCreated: AuctionCreatedDataLoaders.make(),
  questionSubmitted: QuestionSubmittedDataLoaders.make(),
}
