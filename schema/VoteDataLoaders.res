open GraphClient

@gql.enum
type orderBy_Votes =
  | @as("id") ID
  | @as("owner") Owner

@gql.inputObject
type where_Votes = {
  id?: string,
  owner?: string,
}

type t = {
  byId: DataLoader.t<string, option<Vote.vote>>,
  list: DataLoader.t<GraphClient.list<orderBy_Votes, where_Votes>, array<Vote.vote>>,
}

module ById = {
  type data = {vote: Vote.vote}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetVoteDocument"
  let make = DataLoader.makeSingle(async id => {
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res => res.data->Option.map(({vote}) => vote)
    }
  })
}

module List = {
  type data = {votes: array<Vote.vote>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetVotesDocument"
  let make = DataLoader.makeSingle(async variables => {
    switch await GraphClient.executeWithList(document, variables) {
    | exception _ => []
    | res =>
      res.data->Option.mapWithDefault([], ({votes}) =>
        votes->Array.map(vote => (vote :> Vote.vote))
      )
    }
  })
}

let make = () => {
  byId: ById.make,
  list: List.make,
}
