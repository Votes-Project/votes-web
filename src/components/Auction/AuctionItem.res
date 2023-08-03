@val @scope(("import", "meta", "env"))
external auctionContractAddress: option<string> = "VITE_AUCTION_CONTRACT_ADDRESS"

@module("../../abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module AuctionCreatedFragment = %relay(`
  fragment AuctionItem_auctionCreated on AuctionCreated {
    id
    tokenId
    startTime
    endTime
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
  ~auctionSettled as auctionSettledRef=None,
) => {
  let {address} = Wagmi.useAccount()
  let (bidAmount, setBidAmount) = React.useState(_ => None)
  Js.log2("bidAmount: ", bidAmount)
  let auctionCreated = AuctionCreatedFragment.use(auctionCreatedRef)
  let auctionSettled =
    auctionSettledRef->Option.map(auctionSettledRef =>
      AuctionSettledFragment.use(auctionSettledRef)
    )

  let {config} = Wagmi.usePrepareContractWrite(
    ~config={
      address: auctionContractAddress->Belt.Option.getExn,
      abi: auctionContractAbi,
      functionName: "createBid",
      args: [auctionCreated.tokenId],
      value: bidAmount->Option.getWithDefault("0"),
    },
  )

  let {write} = Wagmi.useContractWrite(config)

  let onBidChange = e => {
    let value =
      ReactEvent.Form.currentTarget(e)["value"]->Viem.parseEther->Option.map(BigInt.toString)

    setBidAmount(_ => value)
  }

  let (currentBid, _) = React.useState(_ => BigInt.fromString("0"))
  switch isToday {
  | true =>
    <>
      <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold lg:text-7xl">
        {`VOTE ${auctionCreated.tokenId}`->React.string}
      </h1>
      <div className="flex flex-col ">
        <div className="flex items-center justify-between">
          <p> {"Current Bid"->React.string} </p>
          <p>
            {currentBid->BigInt.toString->React.string}
            {"Ξ"->React.string}
          </p>
        </div>
        <div className="flex items-center justify-between">
          <p> {"Time Left"->React.string} </p>
          <p> {"1h 20m 30s"->React.string} </p>
        </div>
      </div>
      <div className="flex flex-col lg:flex-row w-full lg:items-center justify-around gap-2 py-10">
        <input
          className="flex-1 rounded-2xl px-2 py-4 placeholder:text-lg placeholder:font-bold focus:border-sky-500 focus:outline-none focus:ring-1"
          placeholder="Ξ 0.1 or more"
          step=0.1
          type_="number"
          value={bidAmount
          ->Option.map(BigInt.fromString)
          ->Option.map(Viem.formatEther)
          ->Option.getWithDefault("")}
          onInput={e => onBidChange(e)}
        />
        <button
          className="flex-2 rounded-lg bg-orange-500 px-4 py-3 lg:px-3 lg:py-2 text-center text-white disabled:bg-background-light disabled:text-background text-xl lg:text-lg"
          disabled={!isToday ||
          bidAmount->Option.isNone ||
          bidAmount->Option.getWithDefault("0")->BigInt.fromString < currentBid}
          onClick={_ => write()}>
          {"Place Bid"->React.string}
        </button>
      </div>
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
