@react.component
let make = () => {
  let {queryParams, setParams} = Routes.Main.DailyQuestion.Route.useQueryParams()
  let isOpen = queryParams.question->Option.getWithDefault(false)

  let onClose = () => setParams(~setter=_ => {question: None})

  open ReactModalSheet
  <Sheet isOpen onClose>
    <Sheet.Container>
      <Sheet.Header />
      <Sheet.Content>
        <p> {"Bottom Sheet"->React.string} </p>
      </Sheet.Content>
    </Sheet.Container>
    <Sheet.Backdrop />
  </Sheet>
}
