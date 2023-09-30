let intToI32 = num => {
  let hex = Int.toStringWithRadix(num, ~radix=16)
  if num < 16 {
    let hex = String.padStart(hex, 2, "0")
    String.padEnd(hex, 10 - String.length(hex), "0")
  } else {
    String.padEnd(hex, 10 - String.length(hex), "0")
  }
}

let i32toInt = i32 => {
  let r = RegExp.fromString("0+$")
  switch i32 {
  | "00000000" => Some(0)
  | _ => i32->String.replaceRegExp(r, "")->Int.fromString(~radix=16)
  }
}

let tokenToSubgraphId = tokenId =>
  tokenId->Int.fromString->Option.map(intToI32)->Option.map(id => "0x" ++ id)

let idToGlobalId = (id, typename) =>
  id->Option.map(id => `${typename}:${id}`->ResGraph.Utils.Base64.encode)

type voteType = Normal | Raffle | FlashVote
let wrapTokenId = tokenId => {
  switch tokenId->mod(10) {
  | 0 => FlashVote
  | 5 => FlashVote
  | 9 => Raffle
  | _ => Normal
  }
}

type auctionPhase = Before | During | After

let wrapAuctionPhase = (startTimeMs, endTimeMs) => {
  let now = Date.now()
  if startTimeMs < now && endTimeMs > now {
    During
  } else if startTimeMs > now {
    Before
  } else {
    After
  }
}
