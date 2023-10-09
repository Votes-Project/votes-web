@send
external addEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "addEventListener"
@send
external removeEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "removeEventListener"
@send
external querySelector: (Dom.document, string) => unit = "querySelector"

ReactModal.setAppElement("#root")
@react.component
let make = (~children, ~isOpen) => {
  let {setParams} = Routes.Main.Route.useQueryParams()

  let setDailyQuestion = dailyQuestion => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        contextId: None,
        dailyQuestion,
      },
    )
  }

  let onClose = _ => setDailyQuestion(None)

  React.useEffect0(() => {
    let handleKeyDown = (e: ReactEvent.Keyboard.t) => {
      switch e->ReactEvent.Keyboard.key {
      | "Escape" => setDailyQuestion(None)
      | _ => ()
      }
    }
    document->addEventListener(#keydown, handleKeyDown)

    Some(() => document->removeEventListener(#keydown, handleKeyDown))
  })

  open ReactModalSheet
  <>
    <Sheet className="flex" isOpen onClose rootId={"root"}>
      <Sheet.Container className="lg:min-h-[864px]">
        <Sheet.Header className="bg-secondary noise flex justify-center rounded-t-3xl">
          <DailyQuestion.QuestionHeader />
        </Sheet.Header>
        <Sheet.Scroller
          className="bg-secondary noise px-4 flex flex-col justify-start hide-scrollbar">
          {children}
        </Sheet.Scroller>
      </Sheet.Container>
      <Sheet.Backdrop onTap={onClose} />
    </Sheet>
  </>
}
