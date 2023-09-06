@react.component @relay.deferredComponent
let make = (~children) => {
  open FramerMotion
  <>
    <div className="relative w-full h-full flex flex-col">
      <Motion.Div
        layoutId="background-noise"
        className="wrapper absolute h-full w-full bg-primary noise flex flex-col z-[-1]"
      />
      <Header />
      <main> {children} </main>
      <DailyQuestionSpeedDial />
    </div>
    <div className="bg-background w-full">
      <VotesDetails />
    </div>
  </>
}
