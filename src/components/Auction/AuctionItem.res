module AuctionCreatedFragment = %relay(`
  fragment AuctionItem_auctionCreated on AuctionCreated {
    id
    tokenId
    ...CreateBid_auctionCreated
    ...AuctionCountdown_auctionCreated
  }
`)

module AuctionSettledFragment = %relay(`
  fragment AuctionItem_auctionSettled on AuctionSettled {
    id
    tokenId
    winner
    amount
  }
`)

exception PastAuctionDoesNotExist
@react.component
let make = (
  ~auctionCreated as auctionCreatedRef,
  ~children,
  ~isToday=false,
  ~isSettled=true,
  ~auctionSettled as auctionSettledRef=None,
) => {
  let auctionCreated = AuctionCreatedFragment.use(auctionCreatedRef)
  let auctionSettled =
    auctionSettledRef->Option.map(auctionSettledRef =>
      AuctionSettledFragment.use(auctionSettledRef)
    )

  let (currentBid, _) = React.useState(_ => "0.0000001")

  switch isToday && auctionSettled->Option.isNone {
  | true =>
    <>
      <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold lg:text-7xl">
        {`VOTE ${auctionCreated.tokenId}`->React.string}
      </h1>
      <div className="flex flex-col ">
        <div className="flex items-center justify-between">
          <p> {"Current Bid"->React.string} </p>
          <p>
            {currentBid->React.string}
            {"Ξ"->React.string}
          </p>
        </div>
        <AuctionCountdown queryRef={auctionCreated.fragmentRefs} />
      </div>
      // <RescriptReactErrorBoundary
      //   fallback={_ => {<div> {React.string("Bid Component Failed to Insantiate")} </div>}}>
      <CreateBid queryRef=auctionCreated.fragmentRefs isToday />
      // </RescriptReactErrorBoundary>
      <div className="flex flex-col justify-between"> {children} </div>
      <div className="w-full py-2 text-center">
        {" View
              All
              Bids"->React.string}
      </div>
    </>
  | false =>
    switch auctionSettled {
    | None => raise(PastAuctionDoesNotExist)
    | Some(auctionSettled) =>
      <>
        <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold lg:text-7xl">
          {`VOTE ${auctionSettled.tokenId}`->React.string}
        </h1>
        <h2> {`Winner ${auctionSettled.winner}`->React.string} </h2>
        <h2> {`Winning Bid: ${auctionSettled.amount} Ξ`->React.string} </h2>
      </>
    }
  }
}
