let intToI32 = (num: int): string => {
  let hex = Int.toStringWithRadix(num, ~radix=16)
  if num < 16 {
    let hex = String.padStart(hex, 2, "0")
    String.padEnd(hex, 10 - String.length(hex), "0")
  } else {
    String.padEnd(hex, 10 - String.length(hex), "0")
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
