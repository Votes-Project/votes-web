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
  let startTimeMs = startTime->Float.fromString->Option.mapWithDefault(0., x => x *. 1000.)
  let endTimeMs = endTime->Float.fromString->Option.mapWithDefault(0., x => x *. 1000.)
  let now = Date.now()

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
