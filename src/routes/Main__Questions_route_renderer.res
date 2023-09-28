module Questions = %relay.deferredComponent(Questions.make)

let renderer = Routes.Main.Questions.Route.makeRenderer(
  ~prepareCode=_ => [Questions.preload()],
  ~prepare=({environment}) => {
    QuestionsQuery_graphql.load(~environment, ~variables=(), ~fetchPolicy=StoreOrNetwork)
  },
  ~render=({prepared: queryRef}) => {
    open FramerMotion

    <Motion.Div
      initial={Initial({height: "-100%"})}
      animate={Animate({height: "100%"})}
      transition={{duration: 2.}}
      className="bg-background flex flex-col px-4 py-6 shadow-inner">
      <h1 className="text-5xl font-bold text-default-darker pl-4 drop-shadow-xl">
        {"Questions"->React.string}
      </h1>
      <React.Suspense fallback={<div> {React.string("Loading Questions...")} </div>}>
        <Questions queryRef />
      </React.Suspense>
    </Motion.Div>
  },
)
