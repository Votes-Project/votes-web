@react.component @relay.deferredComponent
let make = (~children) => {
  open FramerMotion
  <>
    <Motion.Div layoutId="background-noise" className="wrapper bg-primary noise flex flex-col">
      <Header />
      <main> {children} </main>
    </Motion.Div>
    <div className="bg-background w-full">
      <VotesDetails />
    </div>
  </>
}
