type t = {
  auction: AuctionDataLoaders.t,
  auctionSettled: AuctionSettledDataLoaders.t,
  auctionCreated: AuctionCreatedDataLoaders.t,
  questionSubmitted: QuestionSubmittedDataLoaders.t,
  auctionBid: AuctionBidDataLoaders.t,
  voteTransfer: VoteTransferDataLoaders.t,
  vote: VoteDataLoaders.t,
  voteContract: VoteContractDataLoaders.t,
  verification: VerificationDataLoaders.t,
  verifications: VerificationsDataLoaders.t,
}

let make = () => {
  auction: AuctionDataLoaders.make(),
  auctionSettled: AuctionSettledDataLoaders.make(),
  auctionCreated: AuctionCreatedDataLoaders.make(),
  questionSubmitted: QuestionSubmittedDataLoaders.make(),
  auctionBid: AuctionBidDataLoaders.make(),
  voteTransfer: VoteTransferDataLoaders.make(),
  vote: VoteDataLoaders.make(),
  voteContract: VoteContractDataLoaders.make(),
  verification: VerificationDataLoaders.make(),
  verifications: VerificationsDataLoaders.make(),
}
