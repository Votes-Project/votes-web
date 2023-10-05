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
    tokenId
    voteContract(id: $voteContractAddress) {
      totalSupply
    }
    auction {
      ...AuctionDisplay_auction
      startTime
    }
    ...Raffle_vote
  }
`)

exception NoVote
@react.component @relay.deferredComponent
let make = (
  ~queryRef=?,
  ~vote: option<RescriptRelay.fragmentRefs<[#SingleVote_node]>>=?,
  ~tokenId: string,
) => {
  let data = queryRef->Option.map(queryRef => Query.usePreloaded(~queryRef))
  let vote = vote->Option.map(vote => Fragment.use(vote))

  let node = switch data {
  | Some({node: Some({fragmentRefs})}) => Some(Fragment.use(fragmentRefs))
  | _ => None
  }

  let vote = node->Option.orElse(vote)
  let auctionType = tokenId->Int.fromString->Option.map(Helpers.wrapTokenId)

  switch (auctionType, vote) {
  | (Some(Raffle), Some({fragmentRefs, voteContract: Some({totalSupply})})) =>
    <ErrorBoundary fallback={_ => "Auction Failed to load"->React.string}>
      <VoteHeader tokenId={tokenId} totalSupply />
      <Raffle vote=fragmentRefs />
    </ErrorBoundary>
  | (
      Some(Normal),
      Some({
        auction: Some({fragmentRefs, startTime}),
        voteContract: Some({totalSupply}),
        owner,
        tokenId,
      }),
    ) =>
    <ErrorBoundary fallback={_ => "Auction Failed to load"->React.string}>
      <VoteHeader tokenId={tokenId} totalSupply startTime />
      <React.Suspense fallback={<div />}>
        <AuctionDisplay owner auction=fragmentRefs tokenId />
      </React.Suspense>
    </ErrorBoundary>
  | (
      Some(FlashVote),
      Some({
        auction: Some({fragmentRefs, startTime}),
        voteContract: Some({totalSupply}),
        owner,
        tokenId,
      }),
    ) =>
    <ErrorBoundary fallback={_ => "Auction Failed to load"->React.string}>
      <VoteHeader tokenId={tokenId} totalSupply startTime />
      <React.Suspense fallback={<div />}>
        <AuctionDisplay owner auction=fragmentRefs tokenId />
      </React.Suspense>
    </ErrorBoundary>
  | _ => raise(NoVote)
  }
}
