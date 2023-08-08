module Verification = {
  type t = {
    unique: bool,
    app: string,
    context: string,
    contextIds: array<string>,
    timestamp?: float,
    sig?: string,
    publicKey?: string,
  }
  type data = {data: t}
}

module Verifications = {
  type t = {contextIds: array<string>, count: int}
  type data = {data: t}
}

module Error = {
  type t = {
    error: bool,
    errorNum: int,
    errorMessage: string,
    code: int,
  }
}

@unboxed
type rec json =
  | @as(false) False
  | @as(true) True
  | @as(null) Null
  | String(string)
  | Number(float)
  | Object(Js.Dict.t<json>)
  | Array(array<json>)

module SDK = {
  @module("brightid_sdk_v5")
  external verifyContextId: (
    ~context: string,
    ~contextId: string,
    ~nodeUrl: string=?,
  ) => Promise.t<JSON.t> = "verifyContextId"

  @module("brightid_sdk_v5")
  external generateDeeplink: (~context: string, ~contextId: string, ~nodeUrl: string=?) => string =
    "generateDeeplink"
}
