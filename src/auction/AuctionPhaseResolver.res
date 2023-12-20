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

let auctionPhase = (startTime, endTime) => {
  open BigInt
  let startTimeMs = startTime->mul(fromInt(1000))
  let endTimeMs = endTime->mul(fromInt(1000))
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
