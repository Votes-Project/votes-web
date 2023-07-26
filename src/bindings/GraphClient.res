type where // need to implement or leave opaque and write bindings

@gql.enum
type orderDirection = | @as("asc") Asc | @as("desc") Desc

@gql.enum
type subgraphError = | @as("allow") Allow | @as("deny") Deny

type single = {id: string, block?: int, subgraphError?: [#allow | #deny]}
type list<'orderBy> = {
  first?: int,
  skip?: int,
  orderBy?: 'orderBy,
  orderDirection?: orderDirection,
  block?: int,
  where?: where,
  subgraphError?: subgraphError,
}
type result<'data> = {data?: 'data}
type document<'data>
@module("../../.graphclient/index.js")
external execute: document<'data> => Promise.t<'data> = "execute"
@module("../../.graphclient/index.js")
external executeWithList: (document<'data>, list<'orderBy>) => Promise.t<'data> = "execute"
@module("../../.graphclient/index.js")
external executeWithId: (document<'data>, single) => Promise.t<'data> = "execute"
