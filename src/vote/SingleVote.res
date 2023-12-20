RescriptRelay.relayFeatureFlags.enableRelayResolvers = true
@module external votesyConstruction: 'a = "/votesy_construction.svg"
module Query = %relay(`
  query SingleVoteQuery($id: ID!) {
    node(id: $id) {
      ...SingleVote_node
    }
  }
`)

module Fragment = %relay(`
  fragment SingleVote_node on Vote {
    owner
    tokenId
    voteType
    contract {
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
exception NoAuction
@react.component @relay.deferredComponent
let make = (
  ~queryRef=?,
  ~vote: option<RescriptRelay.fragmentRefs<[#SingleVote_node]>>,
  ~tokenId,
) => {
  let data = queryRef->Option.map(queryRef => Query.usePreloaded(~queryRef))
  let vote = Fragment.useOpt(vote)
  let {setHeroComponent} = React.useContext(HeroComponentContext.context)

  let auctionRef = React.useCallback0(element => {
    switch element->Nullable.toOption {
    | Some(element) =>
      element->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: End})
    | None => ()
    }
  })

  React.useEffect1(() => {
    setHeroComponent(_ =>
      <div
        className=" lg:w-[50%] w-[80%] md:w-[70%] mx-[10%] mt-8 md:mx-[15%] lg:mx-0 flex align-end lg:pr-20 relative "
        ref={ReactDOM.Ref.callbackDomRef(auctionRef)}>
        {switch Environment.featureFlags {
        | {enableCharts: true} =>
          <div className="relative h-0 w-full pt-[100%]">
            <EmptyVoteChart
              className="rounded-none my-0 mx-auto w-full h-full align-middle min-w-[100px] min-h-[100px]"
            />
          </div>
        | _ =>
          <>
            <div
              className="absolute w-full h-full flex items-center justify-center z-10 backdrop-blur-sm flex-col">
              <h2 className="text-2xl  font-semibold text-center z-10 ">
                {"Data visualization is under construction"->React.string}
              </h2>
              <img
                src={votesyConstruction["default"]}
                className=" w-48 h-48 lg:w-80 lg:h-80"
                alt="Vite logo"
              />
            </div>
            <div className="relative">
              <EmptyVoteChart className="rounded-none w-full mx-auto h-full align-middle" />
            </div>
          </>
        }}
      </div>
    )
    None
  }, [setHeroComponent])

  let node = switch data {
  | Some({node: Some({fragmentRefs})}) => Some(Fragment.use(fragmentRefs))
  | _ => None
  }

  let vote = node->Option.orElse(vote)
  let voteType = vote->Option.flatMap(vote => vote.voteType)

  <div className="px-[5%] ">
    {switch (voteType, vote) {
    | (Some(Raffle), Some({fragmentRefs, contract: {totalSupply}})) =>
      <ErrorBoundary fallback={_ => "Auction Failed to load"->React.string}>
        <VoteHeader tokenId={tokenId} totalSupply startTime={Date.now()->BigInt.fromFloat} />
        <Raffle vote=fragmentRefs />
      </ErrorBoundary>
    | (
        Some(Normal),
        Some({
          auction: Some({fragmentRefs, startTime}),
          contract: {totalSupply},
          owner: Some(owner),
          tokenId,
        }),
      ) =>
      <ErrorBoundary fallback={_ => "Auction Failed to load"->React.string}>
        <VoteHeader
          tokenId={Some(tokenId)}
          totalSupply
          startTime={startTime->BigInt.mul(1000->BigInt.fromInt)}
        />
        <React.Suspense fallback={<div />}>
          <AuctionDisplay owner auction=fragmentRefs />
        </React.Suspense>
      </ErrorBoundary>
    | (
        Some(FlashVote),
        Some({
          auction: Some({fragmentRefs, startTime}),
          contract: {totalSupply},
          owner: Some(owner),
          tokenId,
        }),
      ) =>
      <ErrorBoundary fallback={_ => "Auction Failed to load"->React.string}>
        <VoteHeader
          tokenId={Some(tokenId)}
          totalSupply
          startTime={startTime->BigInt.mul(1000->BigInt.fromInt)}
        />
        <React.Suspense fallback={<div />}>
          <AuctionDisplay owner auction=fragmentRefs />
        </React.Suspense>
      </ErrorBoundary>
    | (Some(FlashVote), Some({auction: None})) => raise(NoAuction)
    | (Some(Normal), Some({auction: None})) => raise(NoAuction)
    | _ => raise(NoVote)
    }}
  </div>
}
