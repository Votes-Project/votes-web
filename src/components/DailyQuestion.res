@send
external addEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "addEventListener"
@send
external removeEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "removeEventListener"

@react.component
let make = () => {
  let {queryParams, setParams} = Routes.Main.DailyQuestion.Route.useQueryParams()
  let isOpen = queryParams.question->Option.getWithDefault(false)

  let onClose = () => setParams(~setter=_ => {question: None})
  let handleBackdropTap = () => setParams(~setter=_ => {question: None})

  React.useEffect0(() => {
    let handleKeyDown = (e: ReactEvent.Keyboard.t) => {
      e->ReactEvent.Keyboard.preventDefault
      switch e->ReactEvent.Keyboard.key {
      | "Escape" => setParams(~setter=_ => {question: None})
      | _ => ()
      }
    }
    document->addEventListener(#keydown, handleKeyDown)

    Some(() => document->removeEventListener(#keydown, handleKeyDown))
  })

  open ReactModalSheet

  <Sheet isOpen onClose>
    <Sheet.Container>
      <Sheet.Header />
      <Sheet.Content>
        <p> {"Bottom Sheet"->React.string} </p>
      </Sheet.Content>
    </Sheet.Container>
    <Sheet.Backdrop onTap={_ => handleBackdropTap()} />
  </Sheet>
}
