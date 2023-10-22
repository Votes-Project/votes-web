let renderer = Routes.Main.Vote.Route.makeRenderer(
  ~prepareCode=_ => [],
  ~prepare=_ => (),
  ~render=({childRoutes}) => {
    <ErrorBoundary fallback={({error}) => JSON.stringifyAny(error)->Option.getExn->React.string}>
      <React.Suspense fallback={<div> {""->React.string} </div>}> {childRoutes} </React.Suspense>
    </ErrorBoundary>
  },
)
