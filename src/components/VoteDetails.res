@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let _ = queryRef
  <div className=" w-full h-full flex flex-col justify-around items-center">
    <div className="flex justify-center items-start w-full flex-2 p-16">
      <EmptyVoteChart className=" static" />
    </div>
    <div className="flex-1 bg-white w-full rounded-xl">
      <div className="w-full"> {"Stats"->React.string} </div>
    </div>
  </div>
}
