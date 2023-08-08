/* @generated */

@@warning("-27-34-37")

module Resolver = {
  @gql.interfaceResolver("node")
  type t =
    | AuctionBid(AuctionBid.auctionBid)
    | AuctionCreated(AuctionCreated.auctionCreated)
    | AuctionSettled(AuctionSettled.auctionSettled)
    | QuestionSubmitted(QuestionSubmitted.questionSubmitted)
    | Verification(Verification.verification)
}

module ImplementedBy = {
  type t = AuctionBid | AuctionCreated | AuctionSettled | QuestionSubmitted | Verification

  let decode = (str: string) =>
    switch str {
    | "AuctionBid" => Some(AuctionBid)
    | "AuctionCreated" => Some(AuctionCreated)
    | "AuctionSettled" => Some(AuctionSettled)
    | "QuestionSubmitted" => Some(QuestionSubmitted)
    | "Verification" => Some(Verification)
    | _ => None
    }

  external toString: t => string = "%identity"
}

type typeMap<'a> = {
  @as("AuctionBid") auctionBid: 'a,
  @as("AuctionCreated") auctionCreated: 'a,
  @as("AuctionSettled") auctionSettled: 'a,
  @as("QuestionSubmitted") questionSubmitted: 'a,
  @as("Verification") verification: 'a,
}

module TypeMap: {
  type t<'value>
  let make: (typeMap<'value>, ~valueToString: 'value => string) => t<'value>

  /** Takes a (stringified) value and returns what type it represents, if any. */
  let getTypeByStringifiedValue: (t<'value>, string) => option<ImplementedBy.t>

  /** Takes a type and returns what value it represents, as string. */
  let getStringifiedValueByType: (t<'value>, ImplementedBy.t) => string
} = {
  external unsafe_toDict: typeMap<'value> => Js.Dict.t<'value> = "%identity"
  external unsafe_toType: string => ImplementedBy.t = "%identity"
  type t<'value> = {
    typeToValue: Js.Dict.t<'value>,
    valueToTypeAsString: Js.Dict.t<string>,
    valueToString: 'value => string,
  }
  let make = (typeMap, ~valueToString) => {
    typeToValue: typeMap->unsafe_toDict,
    valueToTypeAsString: typeMap
    ->unsafe_toDict
    ->Js.Dict.entries
    ->Array.map(((key, value)) => (valueToString(value), key))
    ->Js.Dict.fromArray,
    valueToString,
  }

  let getStringifiedValueByType = (t, typ) =>
    t.typeToValue->Dict.get(typ->ImplementedBy.toString)->Option.getExn->t.valueToString
  let getTypeByStringifiedValue = (t, str) =>
    t.valueToTypeAsString->Dict.get(str)->Option.map(unsafe_toType)
}
