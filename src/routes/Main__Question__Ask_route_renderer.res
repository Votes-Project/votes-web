module AskQuestion = %relay.deferredComponent(CreateVote.make)

module Confirm = %relay.deferredComponent(Confirm.make)

let renderer = Routes.Main.Question.Ask.Route.makeRenderer(
  ~prepareCode=_ => [AskQuestion.preload(), Confirm.preload()],
  ~prepare=_ => (),
  ~render=({childRoutes, confirm}) => {
    <>
      <AskQuestion> {childRoutes} </AskQuestion>
      <ConfirmModal isOpen={confirm->Option.isSome}>
        {switch confirm {
        | Some(_) => <Confirm />
        | None => <> </>
        }}
      </ConfirmModal>
    </>
  },
)
