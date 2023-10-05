open Vote
@val @scope(("process", "env"))
external voteContractAddress: option<string> = "VITE_VOTE_CONTRACT_ADDRESS"

@gql.field
let vote = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<vote> => {
  let id =
    id->ResGraph.Utils.Base64.decode->String.split(":")->Array.get(1)->Option.getWithDefault(id)
  switch await ctx.dataLoaders.vote.byId->DataLoader.load(id) {
  | None => panic("Did not find auction settled with that ID")
  | Some(vote) => vote->Some
  }
}

@gql.field
let votes = async (
  _: Schema.query,
  ~skip=?,
  ~orderBy=?,
  ~orderDirection=?,
  ~where=?,
  ~first=?,
  ~after,
  ~before,
  ~last,
  ~ctx: ResGraphContext.context,
): voteConnection => {
  open VoteDataLoaders
  open GraphClient
  let variables = {
    first: first->Option.getWithDefault(1000),
    skip: skip->Option.getWithDefault(0),
    orderBy: orderBy->Option.getWithDefault(ID),
    orderDirection: orderDirection->Option.getWithDefault(Asc),
    where: where->Option.getWithDefault(({}: where_Votes)),
  }
  let votes = await ctx.dataLoaders.vote.list->DataLoader.load(variables)
  votes->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
}

@gql.field
let voteContract = async (_: vote, ~id, ~ctx: ResGraphContext.context): option<
  VoteContract.voteContract,
> => {
  switch await ctx.dataLoaders.voteContract.byId->DataLoader.load(id) {
  | None => panic("Did not find vote contract with that address")
  | Some(voteContract) => voteContract->Some
  }
}

@gql.field
let auction = async (vote: vote, ~ctx: ResGraphContext.context) => {
  Js.log2("vote: ", vote.auction)
  switch vote.auction->Nullable.toOption {
  | Some(auction) => {...auction, id: auction.id}->Some
  | None =>
    switch await ctx.dataLoaders.auction.byId->DataLoader.load(vote.id) {
    | None => None
    | Some(auction) => auction->Some
    }
  }
}
