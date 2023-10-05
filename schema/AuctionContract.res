@gql.type
type auctionContract = {
  ...NodeInterface.node,
  /* Auction Treasury Address */
  @gql.field
  treasury: string,
  /* Auction Duration */
  @gql.field
  duration: string,
  /* Auction Time Buffer */
  @gql.field
  timeBuffer: string,
  /* Auction Minimum Bid Increment */
  @gql.field
  minBidIncrement: string,
  /* Auction Launched */
  @gql.field
  launched: bool,
  /* Auction Reserve Price */
  @gql.field
  reservePrice: string,
  /* Auction Reserve Address */
  @gql.field
  reserveAddress: string,
  /* Auction Raffle Address */
  @gql.field
  raffleAddress: string,
  /* Auction Votes URI */
  @gql.field
  votesURI: string,
  /* Auction Flash Votes URI */
  @gql.field
  flashVotesURI: string,
  /* Auction Paused */
  @gql.field
  paused: bool,
  /* Auction Votes Token */
  @gql.field
  votesToken: string,
}
