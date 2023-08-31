module Main = %relay.deferredComponent(Main.make)
module LinkBrightID = %relay.deferredComponent(LinkBrightID.make)
module DailyQuestion = %relay.deferredComponent(DailyQuestion.make)

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
  // prepare let's your preload your data. It's fed a bunch of things (more on that later). In the example below, we're using the Relay environment, as well as the slug, that's a path parameter defined in the route definition, like `/campaigns/:slug`.
  ~prepare=({environment, dailyQuestion, linkBrightID, contextId}) => {
    switch (dailyQuestion, linkBrightID, contextId) {
    | (Some(_), Some(_), Some(contextId)) => (
        DailyQuestionQuery_graphql.load(
          ~environment,
          ~variables={contextId: TypedArray.toString(contextId)},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
        LinkBrightIDQuery_graphql.load(
          ~environment,
          ~variables={contextId: TypedArray.toString(contextId)},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
      )
    | (Some(_), None, Some(contextId)) => (
        DailyQuestionQuery_graphql.load(
          ~environment,
          ~variables={contextId: TypedArray.toString(contextId)},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
        None,
      )
    | (None, Some(_), Some(contextId)) => (
        None,
        LinkBrightIDQuery_graphql.load(
          ~environment,
          ~variables={contextId: TypedArray.toString(contextId)},
          ~fetchPolicy=StoreOrNetwork,
        )->Some,
      )
    | _ => (None, None)
    }
  },
  // HINT: This returns a single query ref, but remember you can return _anything_ from here - objects, arrays, tuples, whatever. A hot tip is to return an object that doesn't require a type definition, to leverage type inference.

  // Render receives all the config `prepare` receives, and whatever `prepare` returns itself. It also receives `childRoutes`, which is any rendered route nested inside of it. So, if the route definition of this route has `children` and they match, the rendered output is in `childRoutes`. Each route with children is responsible for rendering its children. This makes layouting easy.

  ~render=({childRoutes, dailyQuestion, linkBrightID, contextId, prepared}) => {
    let (dailyQuestionQueryRef, linkBrightIDQueryRef) = prepared

    <>
      <Main> {childRoutes} </Main>
      <LinkBrightIDModal isOpen={linkBrightID->Option.isSome}>
        {switch (linkBrightID, linkBrightIDQueryRef, contextId) {
        | (Some(_), Some(queryRef), Some(contextId)) =>
          // <RescriptReactErrorBoundary fallback={_ => "Error"->React.string}>
          <LinkBrightID queryRef contextId />
        // </RescriptReactErrorBoundary>
        | _ => React.null
        }}
      </LinkBrightIDModal>
      <DailyQuestionModal isOpen={dailyQuestion->Option.isSome}>
        {switch (dailyQuestion, dailyQuestionQueryRef) {
        | (Some(_), Some(queryRef)) =>
          // <RescriptReactErrorBoundary fallback={_ => "Error"->React.string}>

          <DailyQuestion queryRef />

        // </RescriptReactErrorBoundary>
        | _ => React.null
        }}
      </DailyQuestionModal>
    </>
  },
)
