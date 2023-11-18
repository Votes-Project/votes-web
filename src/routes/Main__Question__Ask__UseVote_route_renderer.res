module UseVoteList = %relay.deferredComponent(UseVoteList.make)
let renderer = Routes.Main.Question.Ask.UseVote.Route.makeRenderer(
  ~prepareCode=_ => [UseVoteList.preload()],
  ~prepare=_ => (),
  ~render=_ => {
    <React.Suspense fallback={<div> {"Loading VOTE tokens..."->React.string} </div>}>
      <UseVoteList />
    </React.Suspense>
  },
)
