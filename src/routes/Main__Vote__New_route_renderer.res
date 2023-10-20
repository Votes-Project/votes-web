let renderer = Routes.Main.Vote.New.Route.makeRenderer(
  ~prepare=_ => (),
  ~render=_ => {
    <React.Suspense fallback={<p> {"Loading"->React.string} </p>}>
      <CreateVote />
    </React.Suspense>
  },
)
