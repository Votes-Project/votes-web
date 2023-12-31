let renderer = Routes.Main.Question.Route.makeRenderer(
  ~prepare=_ => {
    ()
  },
  ~render=({childRoutes}) => {
    <ErrorBoundary fallback={({error}) => JSON.stringifyAny(error)->Option.getExn->React.string}>
      <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
        {childRoutes}
      </React.Suspense>
    </ErrorBoundary>
  },
)
