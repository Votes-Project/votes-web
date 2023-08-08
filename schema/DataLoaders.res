type t = {
  auctionSettled: AuctionSettledDataLoaders.t,
  auctionCreated: AuctionCreatedDataLoaders.t,
  questionSubmitted: QuestionSubmittedDataLoaders.t,
  auctionBid: AuctionBidDataLoaders.t,
  verification: VerificationDataLoaders.t,
}

let make = () => {
  auctionSettled: AuctionSettledDataLoaders.make(),
  auctionCreated: AuctionCreatedDataLoaders.make(),
  questionSubmitted: QuestionSubmittedDataLoaders.make(),
  auctionBid: AuctionBidDataLoaders.make(),
  verification: VerificationDataLoaders.make(),
}
