module Main = %relay.deferredComponent(Main.make)
module DailyQuestion = %relay.deferredComponent(DailyQuestion.make)
module LinkBrightID = %relay.deferredComponent(LinkBrightID.make)

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
    ]->Array.filterMap(v => v),
  ~prepare=({environment, dailyQuestion, linkBrightID, contextId}) => {
    switch (dailyQuestion, linkBrightID, contextId) {
    | (Some(_), Some(_), Some(contextId)) => (
        DailyQuestionQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
        LinkBrightIDQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=StoreOrNetwork,
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
    | (None, Some(_), Some(contextId)) => (
        None,
        LinkBrightIDQuery_graphql.load(
          ~environment,
          ~variables={contextId: contextId},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
      )
    | _ => (None, None)
    }
  },
  ~render=({childRoutes, dailyQuestion, linkBrightID, contextId, prepared}) => {
    let (dailyQuestionQueryRef, linkBrightIDQueryRef) = prepared

    <>
      <Main> {childRoutes} </Main>
      <DailyQuestionModal isOpen={dailyQuestion->Option.isSome && linkBrightID->Option.isNone}>
        {switch (dailyQuestion, dailyQuestionQueryRef) {
        | (Some(_), Some(queryRef)) =>
          // <RescriptReactErrorBoundary fallback={_ => "Error"->React.string}>
          <React.Suspense fallback={<p> {"Loading"->React.string} </p>}>
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
    </>
  },
)
