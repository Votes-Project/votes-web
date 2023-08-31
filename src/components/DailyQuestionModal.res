@send
external addEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "addEventListener"
@send
external removeEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "removeEventListener"

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
    <Sheet className="md:hidden flex" isOpen onClose rootId={"root"}>
      <Sheet.Container className="lg:min-h-[864px]">
        <Sheet.Header className="bg-secondary noise flex justify-center ">
          <DailyQuestion.QuestionHeader />
        </Sheet.Header>
        <Sheet.Scroller
          className="bg-secondary noise px-4 flex flex-col justify-start hide-scrollbar">
          {children}
        </Sheet.Scroller>
      </Sheet.Container>
      <Sheet.Backdrop onTap={onClose} />
    </Sheet>
    <ReactModal
      isOpen
      onRequestClose={onClose}
      className="hidden md:flex "
      style={
        overlay: {
          backgroundColor: "rgba(0,0,0,0.5)",
          outline: "none",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        },
        content: {
          outline: "none",
        },
      }>
      <div className="justify-center items-center flex inset-0 z-50 ">
        <div className="relative w-auto mx-auto max-w-3xl">
          <div
            className="flex flex-col border-0 rounded-xl shadow-xl relative w-full bg-secondary justify-start items-center min-w-[740px] max-h-[890px] noise overflow-scroll hide-scrollbar">
            <div className=" w-full px-4 h-full flex flex-col justify-around">
              <div
                className="w-full  flex justify-center items-center sticky top-0 bg-secondary noise ">
                <DailyQuestion.QuestionHeader />
              </div>
              {children}
            </div>
          </div>
        </div>
      </div>
    </ReactModal>
  </>
}
