/**
 * @RelayResolver
 *
 * @onType Vote
 * @fieldName voteType
 * @rootFragment VoteTypeResolver
 *
 * The type of a vote (Normal | Raffle | FlashVote).
 */
type t = Normal | Raffle | FlashVote

let voteType = tokenId => {
  switch mod(tokenId, 10) {
  | 0 => FlashVote
  | 5 => FlashVote
  | 9 => Raffle
  | _ => Normal
  }
}
module Fragment = %relay(`
  fragment VoteTypeResolver on Vote {
    tokenId
  }
`)

let default = Fragment.makeRelayResolver(({tokenId}) => {
  tokenId->BigInt.toInt->voteType->Some
})
