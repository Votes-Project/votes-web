module UseVoteList = %relay.deferredComponent(UseVoteList.make)
let renderer = Routes.Main.Vote.New.UseVote.Route.makeRenderer(
  ~prepareCode=_ => [UseVoteList.preload()],
  ~prepare=({environment, owner}) => {
    owner->Option.map(owner =>
      UseVoteListQuery_graphql.load(
        ~environment,
        ~variables={owner: owner},
        ~fetchPolicy=StoreOrNetwork,
      )
    )
  },
  ~render=({prepared}) => {
    <React.Suspense fallback={<div> {""->React.string} </div>}>
      {switch prepared {
      | None => React.null
      | Some(queryRef) => <UseVoteList queryRef />
      }}
    </React.Suspense>
  },
)
