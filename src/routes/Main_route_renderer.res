@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module Main = %relay.deferredComponent(Main.make)
module LinkBrightID = %relay.deferredComponent(LinkBrightID.make)
module Stats = %relay.deferredComponent(Stats.make)
// module QuestionQueue = %relay.deferredComponent(QuestionQueue.make)

let contextId = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_contextId")

type initialRender = Loading | CurrentVote | CurrentQuestion | ChildRoutes
let handleInitialRender = (auction: option<AuctionContext.auction>, isLoading, isSubroute) => {
  let hasAnsweredQuestion = {
    open Dom.Storage2
    let timestamp =
      localStorage->getItem("votesdev_answer_timestamp")->Option.map(BigInt.fromString)

    auction
    ->Option.map(auction => auction.startTime)
    ->Option.map(Date.getTime)
    ->Option.map(BigInt.fromFloat)
    ->(Option.equal(_, timestamp, (startTime, lastVoteTimestamp) => startTime < lastVoteTimestamp))
  }

  switch (auction, hasAnsweredQuestion, isSubroute, isLoading) {
  | (_, _, true, _) => ChildRoutes
  | (_, _, _, true) => Loading
  | (Some(_), true, _, _) => CurrentVote
  | (Some(_), false, _, _) => CurrentQuestion
  | _ => ChildRoutes
  }
}

let renderer = Routes.Main.Route.makeRenderer(
  ~prepareCode=({linkBrightID, stats}) => {
    [
      Some(Main.preload()),
      switch linkBrightID {
      | None => None
      | Some(_) => Some(LinkBrightID.preload())
      },
      switch stats {
      | None => None
      | Some(_) => Some(Stats.preload())
      },
    ]->Array.filterMap(v => v)
  },
  ~prepare=({environment, linkBrightID, stats}) => {
    (
      MainQuery_graphql.load(
        ~environment,
        ~variables={
          contextId: contextId->Option.getExn,
          votesContractAddress: Environment.votesContractAddress,
        },
        ~fetchPolicy=StoreOrNetwork,
      ),
      switch (linkBrightID, contextId) {
      | (Some(linkBrightIDKey), Some(contextId)) =>
        LinkBrightIDQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=NetworkOnly,
          ~fetchKey=linkBrightIDKey->Int.toString,
        )->Some
      | _ => None
      },
      switch (stats, contextId) {
      | (Some(statsKey), Some(_)) =>
        StatsQuery_graphql.load(~environment, ~variables=(), ~fetchKey=statsKey->Int.toString)->Some
      | _ => None
      },
    )
  },
  ~render=({childRoutes, linkBrightID, stats, prepared}) => {
    let (queryRef, linkBrightIDQueryRef, statsQueryRef) = prepared

    let {auction, isLoading} = React.useContext(AuctionContext.context)
    let {vote} = React.useContext(VoteContext.context)
    let {question} = React.useContext(QuestionContext.context)

    let location = RelayRouter.Utils.useLocation()
    let isSubroute = location.pathname !== "/"

    <>
      <ErrorBoundary fallback={({error}) => error->React.string}>
        <Main queryRef>
          <React.Suspense fallback={<div />}>
            {switch handleInitialRender(auction, isLoading, isSubroute) {
            | Loading => "Loading"->React.string
            | CurrentVote =>
              <SingleVote
                vote={vote->Option.map(v => v.fragmentRefs)}
                tokenId={auction->Option.map(auction => auction.tokenId)}
              />
            | CurrentQuestion => <SingleQuestion question={question->Option.getExn} />
            | ChildRoutes => childRoutes
            }}
          </React.Suspense>
        </Main>
      </ErrorBoundary>
      <LinkBrightIDModal isOpen={linkBrightID->Option.isSome}>
        {switch (linkBrightID, linkBrightIDQueryRef, contextId) {
        | (Some(_), Some(queryRef), Some(contextId)) =>
          <ErrorBoundary fallback={_ => "Error"->React.string}>
            <React.Suspense
              fallback={<div
                className="w-full h-full flex justify-center items-center text-lg text-white">
                {"Loading"->React.string}
              </div>}>
              <LinkBrightID queryRef contextId />
            </React.Suspense>
          </ErrorBoundary>
        | _ => React.null
        }}
      </LinkBrightIDModal>
      <StatsModal isOpen={stats->Option.isSome}>
        {switch (stats, statsQueryRef, contextId) {
        | (Some(_), Some(queryRef), Some(_)) =>
          <ErrorBoundary fallback={_ => "Error"->React.string}>
            <React.Suspense fallback={<div className="h-[50vh]" />}>
              <Stats queryRef />
            </React.Suspense>
          </ErrorBoundary>
        | _ => React.null
        }}
      </StatsModal>
    </>
  },
)
