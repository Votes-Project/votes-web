exception NoTokenId

type arrowPress = LeftPress | RightPress
@react.component
let make = (~tokenId, ~totalSupply, ~startTime=?) => {
  let newestTokenId = {
    open BigInt
    totalSupply->sub(1->fromInt)
  }

  let tokenId = switch (tokenId, newestTokenId) {
  | (Some(tokenId), _) => tokenId
  | _ => newestTokenId
  }

  let {push} = RelayRouter.Utils.useRouter()

  let handleArrowPress = (direction, tokenId) => {
    open BigInt
    switch direction {
    | LeftPress =>
      let tokenId = tokenId->sub(1->fromInt)
      Routes.Main.Vote.Auction.Route.makeLink(~tokenId=tokenId->toString)->push
    | RightPress =>
      let tokenId = tokenId->add(1->fromInt)
      Routes.Main.Vote.Auction.Route.makeLink(~tokenId=tokenId->toString)->push
    }
  }

  let auctionDateLocale =
    startTime->Option.map(
      Date.toLocaleDateStringWithLocaleAndOptions(_, "en-US", {dateStyle: #long}),
    )

  <div className="flex w-full items-center ">
    <div className="flex gap-2 items-center">
      <button
        disabled={tokenId == BigInt.fromInt(0)}
        onClick={_ => handleArrowPress(LeftPress, tokenId)}
        className="flex h-8 w-8 items-center justify-center rounded-full bg-default-dark lg:bg-primary-dark disabled:bg-default-disabled ">
        <ReactIcons.LuArrowLeft color="white" className=" stroke-[4]" />
      </button>
      <ReactTooltip anchorSelect="#queue-press" content="Question Queue" />
      <button
        onClick={_ => handleArrowPress(RightPress, tokenId)}
        disabled={tokenId === newestTokenId}
        className="flex h-8 w-8 items-center justify-center rounded-full lg:bg-primary-dark bg-default-dark disabled:bg-default-disabled disabled:opacity-50 ">
        <ReactIcons.LuArrowRight color="white" className="stroke-[4]" />
      </button>
      <p className="font-semibold text-background-dark lg:text-active">
        {auctionDateLocale->Option.getWithDefault("")->React.string}
      </p>
    </div>
  </div>
}
