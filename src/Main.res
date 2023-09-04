@react.component @relay.deferredComponent
let make = (~children) => {
  <>
    <div className="wrapper bg-primary noise flex flex-col">
      <Header />
      <main> {children} </main>
    </div>
    <div className="bg-background w-full">
      <VotesDetails />
    </div>
  </>
}
