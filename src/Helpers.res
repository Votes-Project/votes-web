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

module Date = {
  let hourInMilliseconds = 1000. *. 60. *. 60.
  let dayInMilliseconds = hourInMilliseconds *. 24.
  let weekInMilliseconds = dayInMilliseconds *. 7.

  let secondsToMilliseconds = seconds => seconds *. 1000.
}
