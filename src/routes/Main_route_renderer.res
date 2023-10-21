module Main = %relay.deferredComponent(Main.make)
module DailyQuestion = %relay.deferredComponent(DailyQuestion.make)
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
  ~prepareCode=({dailyQuestion, linkBrightID}) => {
    [
      Some(Main.preload()),
      switch dailyQuestion {
      | None => None
      | Some(_) => Some(DailyQuestion.preload())
      },
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
  ~prepare=({environment, dailyQuestion, linkBrightID, contextId}) => {
    switch (dailyQuestion, linkBrightID, contextId) {
    | (Some(_), Some(linkBrightIDKey), Some(contextId)) => (
        MainQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork),
        DailyQuestionQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
        LinkBrightIDQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=NetworkOnly,
          ~fetchKey=linkBrightIDKey->Int.toString,
        )->Some,
      )

    | (Some(_), None, Some(contextId)) => (
        MainQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork),
        DailyQuestionQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
        None,
      )
    | (None, Some(linkBrightIDKey), Some(contextId)) => (
        MainQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork),
        None,
        LinkBrightIDQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=NetworkOnly,
          ~fetchKey=linkBrightIDKey->Int.toString,
        )->Some,
      )
    | _ => (
        MainQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork),
        None,
        None,
      )
    }
  },
  ~render=({
    childRoutes,
    dailyQuestion,
    linkBrightID,
    contextId,
    voteDetails,
    voteDetailsToken,
    prepared,
  }) => {
    let (queryRef, dailyQuestionQueryRef, linkBrightIDQueryRef) = prepared
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
      <DailyQuestionModal isOpen={dailyQuestion->Option.isSome && linkBrightID->Option.isNone}>
        {switch (dailyQuestion, dailyQuestionQueryRef) {
        | (Some(_), Some(queryRef)) =>
          <ErrorBoundary fallback={_ => "Error"->React.string}>
            <React.Suspense
              fallback={<div className="min-h-[896px]"> {"Loading"->React.string} </div>}>
              <DailyQuestion queryRef />
            </React.Suspense>
          </ErrorBoundary>
        | _ => React.null
        }}
      </DailyQuestionModal>
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
