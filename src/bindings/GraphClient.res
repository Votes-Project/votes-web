@gql.enum
type orderDirection = | @as("asc") Asc | @as("desc") Desc

@gql.enum
type subgraphError = | @as("allow") Allow | @as("deny") Deny

type singleVariables = {id: string, block?: int, subgraphError?: [#allow | #deny]}
type listVariables<'orderBy, 'where> = {
  first?: int,
  skip?: int,
  orderBy?: 'orderBy,
  orderDirection?: orderDirection,
  block?: int,
  where?: 'where,
  subgraphError?: subgraphError,
}

type result<'data> = {data?: 'data}
type linkById = {id: string}
type document<'data>
@module("../../.graphclient/index.js")
external execute: document<'data> => Promise.t<'data> = "execute"
@module("../../.graphclient/index.js")
external executeWithList: (document<'data>, listVariables<'orderBy, 'where>) => Promise.t<'data> =
  "execute"
@module("../../.graphclient/index.js")
external executeWithId: (document<'data>, singleVariables) => Promise.t<'data> = "execute"
