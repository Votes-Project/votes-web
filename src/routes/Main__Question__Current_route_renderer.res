module SingleQuestion = %relay.deferredComponent(SingleQuestion.make)
let renderer = Routes.Main.Question.Current.Route.makeRenderer(
  ~prepareCode=_ => [SingleQuestion.preload()],
  ~prepare=({environment, id}) => {
    switch id {
    | None => None
    | Some(id) =>
      Some(
        SingleQuestionQuery_graphql.load(
          ~environment,
          ~variables={id: id},
          ~fetchPolicy=StoreOrNetwork,
        ),
      )
    }
  },
  ~render=({prepared}) => {
    switch prepared {
    | None => <> </>
    | Some(queryRef) => <SingleQuestion queryRef />
    }
  },
)
