/**
 * @RelayResolver
 *
 * @onType Auction
 * @fieldName phase
 * @rootFragment AuctionPhaseResolver
 *
 * The phase of an auction (Before | Active | After).
 */
type t = Before | Active | After

let auctionPhase = (startTime, endTime: Date.t) => {
  open BigInt
  let startTimeMs = startTime->Date.getTime->BigInt.fromFloat
  let endTimeMs = endTime->Date.getTime->BigInt.fromFloat
  let now = Date.now()->fromFloat

  if startTimeMs > now {
    Before
  } else if endTimeMs > now {
    Active
  } else {
    After
  }
}
module Fragment = %relay(`
  fragment AuctionPhaseResolver on Auction {
    startTime
    endTime
  }
`)

let default = Fragment.makeRelayResolver(auction => {
  auctionPhase(auction.startTime, auction.endTime)->Some
})
