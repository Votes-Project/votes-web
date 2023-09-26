module Query = %relay(`
  query SingleVoteQuery($id: ID!, $voteContractAddress: String!) {
    node(id: $id) {
      ...SingleVote_node @arguments(voteContractAddress: $voteContractAddress)
    }
  }
`)

module Fragment = %relay(`
  fragment SingleVote_node on Vote
  @argumentDefinitions(voteContractAddress: { type: "String!" }) {
    owner
    voteContract(id: $voteContractAddress) {
      totalSupply
    }
    auction {
      ...AuctionDisplay_auction
      startTime
    }
  }
`)

exception NoVote
@react.component @relay.deferredComponent
let make = (
  ~queryRef=?,
  ~vote: option<RescriptRelay.fragmentRefs<[#SingleVote_node]>>=?,
  ~tokenId,
  ~children,
) => {
  let data = queryRef->Option.map(queryRef => Query.usePreloaded(~queryRef))
  let newestVote = vote->Option.map(Fragment.use(_))

  let vote =
    data
    ->Option.flatMap(({node}) => node)
    ->Option.map(({fragmentRefs}) => Fragment.use(fragmentRefs))

  let vote = vote->Option.orElse(newestVote)

  let auctionType = tokenId->Option.map(Helpers.wrapTokenId)

  switch (auctionType, vote) {
  | (Some(Raffle), Some({voteContract: Some({totalSupply})})) =>
    <ErrorBoundary fallback={_ => "Auction Failed to load"->React.string}>
      <VoteHeader tokenId={tokenId} totalSupply />
      {"Raffle"->React.string}
    </ErrorBoundary>
  | (
      Some(Normal),
      Some({auction: Some({fragmentRefs, startTime}), voteContract: Some({totalSupply}), owner}),
    ) =>
    <ErrorBoundary fallback={_ => "Auction Failed to load"->React.string}>
      <VoteHeader tokenId={tokenId} totalSupply startTime />
      <React.Suspense fallback={<div />}>
        <AuctionDisplay owner auction={Some(fragmentRefs)}> {children} </AuctionDisplay>
      </React.Suspense>
    </ErrorBoundary>
  | (
      Some(FlashVote),
      Some({auction: Some({fragmentRefs, startTime}), voteContract: Some({totalSupply}), owner}),
    ) =>
    <ErrorBoundary fallback={_ => "Auction Failed to load"->React.string}>
      <VoteHeader tokenId={tokenId} totalSupply startTime />
      <React.Suspense fallback={<div />}>
        <AuctionDisplay owner auction={Some(fragmentRefs)}> {children} </AuctionDisplay>
      </React.Suspense>
    </ErrorBoundary>
  | _ => raise(NoVote)
  }
}
