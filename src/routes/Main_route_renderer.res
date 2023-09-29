@val @scope(("import", "meta", "env"))
external voteContractAddress: option<string> = "VITE_VOTES_CONTRACT_ADDRESS"
exception NoVoteContractAddress
let voteContract = switch voteContractAddress {
| None => raise(NoVoteContractAddress)
| Some(address) => address
}

module Main = %relay.deferredComponent(Main.make)
module DailyQuestion = %relay.deferredComponent(DailyQuestion.make)
module LinkBrightID = %relay.deferredComponent(LinkBrightID.make)
// module VoteDetails = %relay.deferredComponent(VoteDetails.make)
// module QuestionQueue = %relay.deferredComponent(QuestionQueue.make)

let renderer = Routes.Main.Route.makeRenderer(
  ~prepareCode=({dailyQuestion, linkBrightID}) =>
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
  ~prepare=({environment, dailyQuestion, linkBrightID, contextId}) => {
    switch (dailyQuestion, linkBrightID, contextId) {
    | (Some(_), Some(linkBrightIDKey), Some(contextId)) => (
        MainQuery_graphql.load(
          ~environment,
          ~variables={voteContract: voteContract},
          ~fetchPolicy=StoreOrNetwork,
        ),
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
        MainQuery_graphql.load(
          ~environment,
          ~variables={voteContract: voteContract},
          ~fetchPolicy=StoreOrNetwork,
        ),
        DailyQuestionQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
        None,
      )
    | (None, Some(linkBrightIDKey), Some(contextId)) => (
        MainQuery_graphql.load(
          ~environment,
          ~variables={voteContract: voteContract},
          ~fetchPolicy=StoreOrNetwork,
        ),
        None,
        LinkBrightIDQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=NetworkOnly,
          ~fetchKey=linkBrightIDKey->Int.toString,
        )->Some,
      )
    | _ => (
        MainQuery_graphql.load(
          ~environment,
          ~variables={voteContract: voteContract},
          ~fetchPolicy=StoreOrNetwork,
        ),
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

    <>
      <Main queryRef>
        <div className="relative"> {childRoutes} </div>
      </Main>
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
        | (Some(_), None, _) =>
          <React.Suspense fallback={<p> {"Loading"->React.string} </p>}>
            <OwnedVotesList />
          </React.Suspense>
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
