type t
type sameSite = | @as("strict") Strict | @as("lax") Lax | @as("none") None
type cookie = {
  domain: string,
  expires: float,
  name: string,
  partitioned: bool,
  path: string,
  sameSite: sameSite,
  secure: bool,
  value: string,
}

@unboxed type getParams = Options({name: string, url?: string}) | Name(string)
@send external get: (t, getParams) => Promise.t<option<cookie>> = "get"
@send external getAll: (t, getParams) => Promise.t<array<cookie>> = "getAll"

type setOptions = {
  name: string,
  value: string,
  domain?: string,
  expires?: float,
  path?: string,
  sameSite?: sameSite,
  partitioned?: bool,
}
@send external set: (t, string, string) => Promise.t<unit> = "set"
@send external setWithOptions: (t, setOptions) => Promise.t<unit> = "set"

@unboxed
type deleteParams =
  Options({name: string, url?: string, partitioned?: bool, path?: string}) | Name(string)
@send external make: (t, deleteParams) => Promise.t<unit> = "delete"
