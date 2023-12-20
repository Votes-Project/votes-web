// Cursor is left opaque since we don't really need to mess with it
type cursor

module Timestamp = {
  type t = Date.t
  let parse: JSON.t => option<t> = v => {
    switch v {
    | String(str) => Some(Date.fromString(str))
    | Number(timestamp) => Some(Date.fromTime(timestamp))
    | _ => None
    }
  }
  let serialize: t => JSON.t = d => d->Date.toJSON->Option.getExn->String
}

module BigInt = {
  type t = BigInt.t

  let parse: JSON.t => option<t> = v =>
    switch v {
    | String(str) => Some(BigInt.fromString(str))
    | Number(num) => Some(BigInt.fromFloat(num))
    | _ => None
    }

  let serialize: t => JSON.t = n => n->BigInt.toString->String
}
