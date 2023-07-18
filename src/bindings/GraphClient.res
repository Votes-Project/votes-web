type nodeVars = {id: string, block?: int, subgraphError?: [#allow | #deny]}
type where // need to implement or leave opaque and write bindings
type connectionVars = {
  first?: int,
  skip?: int,
  orderBy?: string,
  orderDirection?: string,
  block?: int,
  where?: where,
  subgraphError?: [#allow | #deny],
}
type result<'data> = {data?: 'data}
type document<'data>
@module("../../.graphclient/index.js")
external execute: document<'data> => Promise.t<'data> = "execute"
@module("../../.graphclient/index.js")
external executeWithVars: (document<'data>, connectionVars) => Promise.t<'data> = "execute"
@module("../../.graphclient/index.js")
external executeWithId: (document<'data>, nodeVars) => Promise.t<'data> = "execute"
