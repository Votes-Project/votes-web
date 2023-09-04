@val @scope(("import", "meta", "env"))
external auctionContractAddress: option<string> = "VITE_AUCTION_CONTRACT_ADDRESS"

@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module AuctionCreatedFragment = %relay(`
  fragment CreateBid_auctionCreated on AuctionCreated {
    tokenId
  }
`)

exception ContractWriteDoesNotExist
@react.component
let make = (~queryRef as auctionCreatedRef, ~isToday) => {
  let (bidAmount, setBidAmount) = React.useState(_ => "")
  let auctionCreated = AuctionCreatedFragment.use(auctionCreatedRef)

  let {config} = Wagmi.usePrepareContractWrite(
    ~config={
      address: auctionContractAddress->Belt.Option.getExn,
      abi: auctionContractAbi,
      functionName: "createBid",
      value: bidAmount->Viem.parseEther->Option.getWithDefault(BigInt.fromString("0")),
      args: [auctionCreated.tokenId->Int.fromString],
    },
  )

  let (currentBid, _) = React.useState(_ => "")

  let onBidChange = e => {
    let value = ReactEvent.Form.currentTarget(e)["value"]
    setBidAmount(_ => value)
  }

  let createBid = Wagmi.useContractWrite({
    ...config,
    onSettled: (data, error) => {
      //handle transaction
      ()
    },
  })

  let handleCreateBid = () =>
    switch createBid.write {
    | Some(createBid) => createBid()
    | None => raise(ContractWriteDoesNotExist)
    }

  <div className="flex flex-col lg:flex-row w-full lg:items-center justify-around gap-2 py-10">
    <input
      className="flex-1 rounded-2xl px-2 py-4 placeholder:text-lg placeholder:font-bold
       bg-background-light border-background-dark
       lg:bg-secondary  focus:outline-none focus:ring-1 [appearance:textfield]
       [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
      placeholder="Ξ 0.1 or more"
      step=0.1
      type_="number"
      value={bidAmount}
      onInput={e => onBidChange(e)}
    />
    <button
      className="flex-2 rounded-lg bg-active px-4 py-3 lg:px-3 lg:py-2 text-center text-white disabled:bg-default-disabled disabled:text-background-light text-xl lg:text-lg"
      disabled={!isToday ||
      bidAmount == "" ||
      bidAmount->Float.fromString->Option.equal(currentBid->Float.fromString, (a, b) => a < b)}
      onClick={_ => handleCreateBid()}>
      {"Place Bid"->React.string}
    </button>
  </div>
}
