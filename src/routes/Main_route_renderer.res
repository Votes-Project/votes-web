module Main = %relay.deferredComponent(Main.make)
module LinkBrightID = %relay.deferredComponent(LinkBrightID.make)
// module VoteDetails = %relay.deferredComponent(VoteDetails.make)
// module QuestionQueue = %relay.deferredComponent(QuestionQueue.make)

type initialRender = Loading | CurrentVote | CurrentQuestion | ChildRoutes
let handleInitialRender = (auction: option<AuctionContext.auction>, isLoading, isSubroute) => {
  let hasAnsweredQuestion = {
    open Dom.Storage2
    open BigInt
    let timestamp = localStorage->getItem("votes_answer_timestamp")->Option.getWithDefault("0")

    let auctionStartTime =
      auction->Option.map(auction => auction.startTime)->Option.getWithDefault("0")

    fromString(auctionStartTime)->mul(1000->fromInt) < timestamp->fromString
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
  ~prepareCode=({linkBrightID}) => {
    [
      Some(Main.preload()),
      switch linkBrightID {
      | None => None
      | Some(_) => Some(LinkBrightID.preload())
      },
      // switch voteDetails {
      // | None => None
      // | Some(_) => Some(VoteDetails.preload())
      // },
    ]->Array.filterMap(v => v)
  },
  ~prepare=({environment, linkBrightID, contextId}) => {
    (
      MainQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork),
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
    )
  },
  ~render=({childRoutes, linkBrightID, contextId, voteDetails, voteDetailsToken, prepared}) => {
    let (queryRef, linkBrightIDQueryRef) = prepared
    let {auction, isLoading} = React.useContext(AuctionContext.context)
    let {vote} = React.useContext(VoteContext.context)

    let mainSubroute = Routes.Main.Route.useActiveSubRoute()
    let voteSubroute = Routes.Main.Vote.Route.useActiveSubRoute()

    let isSubroute = mainSubroute->Option.isSome || voteSubroute->Option.isSome

    <>
      <ErrorBoundary fallback={({error}) => error->React.string}>
        <Main queryRef>
          <React.Suspense fallback={<p> {"Loading"->React.string} </p>}>
            {switch handleInitialRender(auction, isLoading, isSubroute) {
            | Loading => "Loading"->React.string
            | CurrentVote =>
              <SingleVote
                vote={vote->Option.getExn} tokenId={auction->Option.map(auction => auction.tokenId)}
              />
            | CurrentQuestion => <SingleQuestion />
            | ChildRoutes => childRoutes
            }}
          </React.Suspense>
        </Main>
      </ErrorBoundary>
      <LinkBrightIDModal isOpen={linkBrightID->Option.isSome}>
        {switch (linkBrightID, linkBrightIDQueryRef, contextId) {
        | (Some(_), Some(queryRef), Some(contextId)) =>
          <ErrorBoundary fallback={_ => "Error"->React.string}>
            <React.Suspense fallback={<p> {"Loading"->React.string} </p>}>
              <LinkBrightID queryRef contextId />
            </React.Suspense>
          </ErrorBoundary>
        | _ => React.null
        }}
      </LinkBrightIDModal>
      <VoteDetailsSidebar isOpen={voteDetails->Option.isSome}>
        {switch (voteDetails, voteDetailsToken, Some()) {
        | (Some(_), Some(_), Some(queryRef)) =>
          <React.Suspense fallback={<p> {"Loading"->React.string} </p>}>
            <VoteDetails queryRef />
          </React.Suspense>
        | _ => React.null
        }}
      </VoteDetailsSidebar>
    </>
  },
)
