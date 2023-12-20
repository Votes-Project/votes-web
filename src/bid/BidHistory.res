module BidItem = {
  module Fragment = %relay(`
  fragment BidHistory_BidItem_auctionBid on AuctionBid {
    id
    bidder
    amount
    blockTimestamp
  }
`)
  @react.component
  let make = (~bid, ~winner) => {
    let {amount, bidder, id, blockTimestamp} = Fragment.use(bid)
    let amount = amount->Viem.formatUnits(18)

    let bidTime =
      blockTimestamp
      ->BigInt.mul(BigInt.fromInt(1000))
      ->BigInt.toFloat
      ->Date.fromTime
      ->Date.toLocaleDateString

    let provider = Wagmi.PublicClient.use()

    <li className="border-b p-3 my-2 rounded-xl bg-default-light" key=id>
      <div className="font-semibold flex items-center justify-between">
        <div className="flex items-center">
          <ShortAddress.Davatar.Image
            size=36 address={bidder} provider uri={Nullable.null} generatedAvatarType=Jazzicon
          />
          <div className="flex flex-col px-2">
            <div className="flex items-center gap-2">
              <ShortAddress address={Some(bidder)} avatar={false} />
              {switch winner {
              | Some(winner) if winner == bidder =>
                <div className="flex items-center gap-2">
                  <p className="text-sm text-default-darker"> {"🏆"->React.string} </p>
                </div>
              | _ => React.null
              }}
            </div>
            <p className="text-sm text-default-darker"> {bidTime->React.string} </p>
          </div>
        </div>
        <div className="flex gap-2 text-md">
          <p> {`Ξ ${amount}`->React.string} </p>
          <p> {"🔗"->React.string} </p>
        </div>
      </div>
    </li>
  }
}

module Fragment = %relay(`
  fragment BidHistory_auction on Auction
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 1000 }
    orderBy: { type: "AuctionBid_orderBy", defaultValue: blockTimestamp }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    where: { type: "AuctionBid_filter" }
  ) {
    tokenId
    bidder
    bids(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
      where: $where
    ) {
      id
      ...BidHistory_BidItem_auctionBid
    }
  }
  `)

@react.component
let make = (~bids) => {
  let {bids, tokenId, bidder} = Fragment.use(bids)
  <>
    <header className=" flex flex-row gap-2">
      <div className="relative bg-default-light rounded-xl">
        <EmptyVoteChart className="h-10" />
      </div>
      <div className="flex flex-col gap-2">
        <h2 className="text-3xl font-bold text-default lg:text-primary-dark ">
          {"Bids For"->React.string}
        </h2>
        <h1 className="text-5xl font-bold text-active lg:text-default-darker">
          {`VOTE ${tokenId->BigInt.toString}`->React.string}
        </h1>
      </div>
    </header>
    <ul
      className="h-[35vh] lg:bg-primary rounded-xl self-center w-full m-4 p-4 gap-2 overflow-y-scroll hide-scrollbar">
      {switch bids {
      | [] =>
        <div className="w-full h-full flex justify-center items-center">
          <p className="text-3xl font-semibold"> {"Bids will appear here"->React.string} </p>
        </div>
      | bids =>
        bids
        ->Array.map(({id, fragmentRefs}) => {
          <BidItem key=id bid={fragmentRefs} winner={bidder} />
        })
        ->React.array
      }}
    </ul>
  </>
}
