open GraphClient

type votesArgs<'orderBy, 'where> = {
  first: option<int>,
  skip: option<int>,
  orderBy: 'orderBy,
  orderDirection: option<orderDirection>,
  where: 'where,
}

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
  list: DataLoader.t<votesArgs<option<orderBy_Votes>, option<where_Votes>>, array<Vote.vote>>,
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
  let make = DataLoader.makeSingle(async args => {
    switch await GraphClient.executeWithList(
      document,
      {
        first: args.first->Option.getWithDefault(100),
        skip: args.skip->Option.getWithDefault(0),
        orderBy: args.orderBy->Option.getWithDefault(ID),
        orderDirection: args.orderDirection->Option.getWithDefault(Asc),
        where: args.where->Option.getWithDefault(({}: where_Votes)),
      },
    ) {
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
