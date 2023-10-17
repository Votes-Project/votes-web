type t = New | Old | Used | Unused | Owned(option<string>)
let parse = str =>
  switch str {
  | "newest" => Some(New)
  | "oldest" => Some(Old)
  | "used" => Some(Used)
  | "unused" => Some(Unused)
  | "0x0" => Some(Owned(None))
  | maybeAddress =>
    if Viem.isAddress(maybeAddress) {
      Some(Owned(Some(maybeAddress)))
    } else {
      None
    }
  }
let serialize = t =>
  switch t {
  | New => "newest"
  | Old => "oldest"
  | Used => "used"
  | Unused => "unused"
  | Owned(Some(address)) => address
  | Owned(None) => "0x0"
  }
