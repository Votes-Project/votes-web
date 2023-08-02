@send external innerWidth: Dom.window => int = "innerWidth"

let veryShortENS = ens => {
  [
    ens->String.substring(~start=0, ~end=1),
    ens->String.substring(~start=ens->String.length - 3, ~end=ens->String.length),
  ]->Array.joinWith("...")
}

let veryShortAddress = address => {
  [
    address->String.substring(~start=0, ~end=3),
    address->String.substring(~start=address->String.length - 1, ~end=address->String.length),
  ]->Array.joinWith("...")
}

let shortENS = ens => {
  if ens->String.length < 15 || window->innerWidth > 480 {
    ens
  } else {
    [
      ens->String.substring(~start=0, ~end=4),
      ens->String.substring(~start=ens->String.length - 8, ~end=8),
    ]->Array.joinWith("...")
  }
}

let useShortAddress = address => {
  address->Option.map(address =>
    [
      address->String.substring(~start=0, ~end=4),
      address->String.substring(~start=38, ~end=42),
    ]->Array.joinWith("...")
  )
}
