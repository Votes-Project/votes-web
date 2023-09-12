module Main = %relay.deferredComponent(Main.make)
module DailyQuestion = %relay.deferredComponent(DailyQuestion.make)
module LinkBrightID = %relay.deferredComponent(LinkBrightID.make)
// module VoteDetails = %relay.deferredComponent(VoteDetails.make)
// module QuestionQueue = %relay.deferredComponent(QuestionQueue.make)

let renderer = Routes.Main.Route.makeRenderer(
  ~prepareCode=({dailyQuestion, linkBrightID, voteDetails}) =>
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
    ]->Array.filterMap(v => v),
  ~prepare=({
    environment,
    dailyQuestion,
    linkBrightID,
    contextId,
    voteDetails,
    voteDetailsToken,
  }) => {
    switch (dailyQuestion, linkBrightID, contextId) {
    | (Some(_), Some(linkBrightIDKey), Some(contextId)) => (
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
        DailyQuestionQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
        None,
      )
    | (None, Some(linkBrightIDKey), Some(contextId)) => (
        None,
        LinkBrightIDQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=NetworkOnly,
          ~fetchKey=linkBrightIDKey->Int.toString,
        )->Some,
      )
    | _ => (None, None)
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
    let (dailyQuestionQueryRef, linkBrightIDQueryRef) = prepared
    <>
      <Main>
        <div className="relative">
          <DailyQuestionSpeedDial />
          {childRoutes}
        </div>
      </Main>
      <DailyQuestionModal isOpen={dailyQuestion->Option.isSome && linkBrightID->Option.isNone}>
        {switch (dailyQuestion, dailyQuestionQueryRef) {
        | (Some(_), Some(queryRef)) =>
          // <RescriptReactErrorBoundary fallback={_ => "Error"->React.string}>
          <React.Suspense
            fallback={<div className="min-h-[896px]"> {"Loading"->React.string} </div>}>
            <DailyQuestion queryRef />
          </React.Suspense>

        // </RescriptReactErrorBoundary>
        | _ => React.null
        }}
      </DailyQuestionModal>
      <LinkBrightIDModal isOpen={linkBrightID->Option.isSome}>
        {switch (linkBrightID, linkBrightIDQueryRef, contextId) {
        | (Some(_), Some(queryRef), Some(contextId)) =>
          // <RescriptReactErrorBoundary fallback={_ => "Error"->React.string}>
          <React.Suspense fallback={<p> {"Loading"->React.string} </p>}>
            <LinkBrightID queryRef contextId />
          </React.Suspense>
        // </RescriptReactErrorBoundary>
        | _ => React.null
        }}
      </LinkBrightIDModal>
      <VoteDetailsSidebar isOpen={voteDetails->Option.isSome}>
        {switch (voteDetails, voteDetailsToken, None) {
        | (Some(_), None, _) =>
          <React.Suspense fallback={<p> {"Loading"->React.string} </p>}>
            <OwnedVotesList />
          </React.Suspense>
        | (Some(_), Some(token), Some(queryRef)) =>
          <React.Suspense fallback={<p> {"Loading"->React.string} </p>}>
            <VoteDetails queryRef />
          </React.Suspense>
        | _ => React.null
        }}
      </VoteDetailsSidebar>
    </>
  },
)
