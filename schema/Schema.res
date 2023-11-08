@gql.type
type query

module Timestamp: {
  /** A timestamp. */
  @gql.scalar
  type t = Date.t

  let parseValue: ResGraph.GraphQLLiteralValue.t => option<t>
  let serialize: t => ResGraph.GraphQLLiteralValue.t
} = {
  type t = Date.t

  open ResGraph.GraphQLLiteralValue

  let parseValue = v => {
    switch v {
    | String(str) => Some(Date.fromString(str))
    | Number(timestamp) => Some(Date.fromTime(timestamp))
    | _ => None
    }
  }

  let serialize = d => d->Date.toJSON->Option.getExn->String
}

module BigInt: {
  /** A number with arbitrary precision */
  @gql.scalar
  type t = BigInt.t

  let parseValue: ResGraph.GraphQLLiteralValue.t => option<t>
  let serialize: t => ResGraph.GraphQLLiteralValue.t
} = {
  type t = BigInt.t

  open ResGraph.GraphQLLiteralValue

  let parseValue = v =>
    switch v {
    | String(str) => Some(BigInt.fromString(str))
    | Number(num) => Some(BigInt.fromFloat(num))
    | _ => None
    }

  let serialize = n => n->BigInt.toString->String
}
