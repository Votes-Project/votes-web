open Vote

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
let newestVote = async (
  _: Schema.query,
  ~voteContractAddress,
  ~ctx: ResGraphContext.context,
): option<vote> => {
  let {totalSupply} = switch await ctx.dataLoaders.voteContract.byId->DataLoader.load(
    voteContractAddress,
  ) {
  | None => panic("Did not find vote contract")
  | Some(voteContract) =>
    ctx.dataLoaders.voteContract.byId->DataLoader.prime(Some(voteContract))
    voteContract
  }
  let id = {
    open BigInt
    BigInt.fromString(totalSupply)->sub(BigInt.fromInt(1))->toInt->Helpers.intToI32
  }
  switch await ctx.dataLoaders.vote.byId->DataLoader.load(id) {
  | None => panic("Did not find newest vote")
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
let auction = async (vote: vote, ~ctx: ResGraphContext.context) => {
  switch vote.auction->Nullable.toOption {
  | Some(auction) =>
    ctx.dataLoaders.auction.byId->DataLoader.prime(Some(auction))
    auction->Some
  | None => None
  }
}

/* The token ID of the vote token */
@gql.field
let tokenId = (vote: vote): Schema.BigInt.t => vote.tokenId->BigInt.fromString
