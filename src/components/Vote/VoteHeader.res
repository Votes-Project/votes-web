exception NoTokenId

type arrowPress = LeftPress | RightPress
@react.component
let make = (~tokenId, ~totalSupply, ~startTime=?) => {
  let newestTokenId =
    totalSupply->Int.fromString->Option.map(totalSupply => (totalSupply - 1)->Int.toString)

  let tokenId = switch (tokenId->Int.fromString, newestTokenId) {
  | (Some(tokenId), _) => tokenId->Int.toString
  | (None, Some(newestTokenId)) => newestTokenId
  | _ => raise(NoTokenId)
  }

  let {push} = RelayRouter.Utils.useRouter()

  let handleArrowPress = (direction, tokenId) => {
    switch (direction, tokenId) {
    | (LeftPress, Some(tokenId)) =>
      let tokenId = tokenId - 1
      Routes.Main.Vote.Auction.Route.makeLink(~tokenId=tokenId->Int.toString)->push
    | (RightPress, Some(tokenId)) =>
      let tokenId = tokenId + 1
      Routes.Main.Vote.Auction.Route.makeLink(~tokenId=tokenId->Int.toString)->push
    | _ => ()
    }
  }
  let handleQueuePress = () => {
    Routes.Main.Queue.Route.makeLink()->push
  }

  let auctionDateLocale =
    startTime
    ->Option.flatMap(Float.fromString)
    ->Option.map(startTime => startTime *. 1000.)
    ->Option.map(todaysStartTime =>
      todaysStartTime
      ->Date.fromTime
      ->Date.toLocaleDateStringWithLocaleAndOptions("en-US", {dateStyle: #long})
    )

  <div className="flex w-full items-center ">
    <div className="flex gap-2 items-center">
      <button
        disabled={tokenId == "0"}
        onClick={_ => handleArrowPress(LeftPress, Int.fromString(tokenId))}
        className="flex h-8 w-8 items-center justify-center rounded-full bg-default-dark lg:bg-primary-dark disabled:bg-default-disabled ">
        <ReactIcons.LuArrowLeft color="white" className=" stroke-[4]" />
      </button>
      <ReactTooltip anchorSelect="#queue-press" content="Question Queue" />
      <button
        onClick={_ => handleArrowPress(RightPress, Int.fromString(tokenId))}
        disabled={Some(tokenId) === newestTokenId}
        className="flex h-8 w-8 items-center justify-center rounded-full lg:bg-primary-dark bg-default-dark disabled:bg-default-disabled disabled:opacity-50 ">
        <ReactIcons.LuArrowRight color="white" className="stroke-[4]" />
      </button>
      <p className="font-semibold text-background-dark lg:text-active">
        {auctionDateLocale->Option.getWithDefault("")->React.string}
      </p>
    </div>
    <div className="flex flex-1 justify-end">
      <button
        id="queue-press"
        onClick={_ => handleQueuePress()}
        className=" self-end flex h-10 w-10 items-center justify-center rounded-full lg:bg-primary-dark bg-default-dark disabled:bg-default-disabled disabled:opacity-50 ">
        <ReactIcons.LuListOrdered color="white" size="1.5rem" />
      </button>
    </div>
  </div>
}
