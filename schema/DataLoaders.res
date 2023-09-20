type t = {
  auction: AuctionDataLoaders.t,
  auctionSettled: AuctionSettledDataLoaders.t,
  auctionCreated: AuctionCreatedDataLoaders.t,
  questionSubmitted: QuestionSubmittedDataLoaders.t,
  auctionBid: AuctionBidDataLoaders.t,
  verification: VerificationDataLoaders.t,
  voteTransfer: VoteTransferDataLoaders.t,
  vote: VoteDataLoaders.t,
  voteContract: VoteContractDataLoaders.t,
}

let make = () => {
  auction: AuctionDataLoaders.make(),
  auctionSettled: AuctionSettledDataLoaders.make(),
  auctionCreated: AuctionCreatedDataLoaders.make(),
  questionSubmitted: QuestionSubmittedDataLoaders.make(),
  auctionBid: AuctionBidDataLoaders.make(),
  verification: VerificationDataLoaders.make(),
  voteTransfer: VoteTransferDataLoaders.make(),
  vote: VoteDataLoaders.make(),
  voteContract: VoteContractDataLoaders.make(),
}
