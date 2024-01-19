module Main = %relay.deferredComponent(Main.make)
module LinkBrightID = %relay.deferredComponent(LinkBrightID.make)
module Stats = %relay.deferredComponent(Stats.make)

let contextId = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_contextId")

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
          voteContractAddress: Environment.voteContractAddress,
          questionsContractAddress: Environment.questionsContractAddress,
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
        StatsQuery_graphql.load(
          ~environment,
          ~variables={id: contextId->Option.getExn},
          ~fetchKey=statsKey->Int.toString,
        )->Some
      | _ => None
      },
    )
  },
  ~render=({childRoutes, linkBrightID, stats, prepared}) => {
    let (queryRef, linkBrightIDQueryRef, statsQueryRef) = prepared
    <>
      <ErrorBoundary
        fallback={({error}) =>
          "Something went wrong connecting to Votes. Most likely this is a server issue"->React.string}>
        <Main queryRef>
          <React.Suspense fallback={<div />}> {childRoutes} </React.Suspense>
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
