module Fragment = %relay(`
  fragment HeaderStats_verifications on Verifications {
    ...VoterCount_verifications
  }
`)
@react.component
let make = (~verifications) => {
  let verifications = Fragment.use(verifications)
  let {alerts} = React.useContext(StatsAlertContext.context)
  let {setParams} = Routes.Main.Route.useQueryParams()
  let handleStats = _ => {
    setParams(
      ~navigationMode_=Push,
      ~removeNotControlledParams=false,
      ~shallow=false,
      ~setter=c => {...c, stats: Some(0)},
    )
  }

  <FramerMotion.Button
    onClick=handleStats
    layoutId="stats"
    layout=True
    className="relative bg-secondary hover:bg-secondary  hover:cursor-pointer rounded-xl flex items-center font-semibold mr-4 px-2 h-10 justify-center transition-all">
    {switch alerts {
    | [] => React.null
    | _ => <Stats.Alert />
    }}
    <p className="text-lg text-active  ml-1 mr-3"> {"Voters"->React.string} </p>
    <div className="flex items-center justify-around text-default-darker">
      <ReactIcons.LuVote size="1.5rem" />
      <ErrorBoundary fallback={_ => "N/A"->React.string}>
        <React.Suspense fallback={<> </>}>
          <VoterCount verifications={verifications.fragmentRefs} />
        </React.Suspense>
      </ErrorBoundary>
    </div>
  </FramerMotion.Button>
}
