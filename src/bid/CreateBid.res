@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module Fragment = %relay(`
  fragment CreateBid_auction on Auction {
    tokenId
    amount
    bidder
    phase
    contract {
      minBidIncrement
      reservePrice
    }
  }
`)

exception ContractWriteDoesNotExist
@react.component
let make = (~auction) => {
  let {address} = Wagmi.Account.use()
  let {data: balance} = Wagmi.useBalance({address: address})

  let (bidAmount, setBidAmount) = React.useState(_ => "")
  let auction = Fragment.use(auction)

  let onBidChange = e => {
    let value = ReactEvent.Form.currentTarget(e)["value"]
    setBidAmount(_ => value)
  }

  let minBid = {
    open BigInt
    switch auction.bidder {
    | None => auction.contract.reservePrice
    | Some(_) =>
      let current = auction.amount
      let minIncrementPercent = auction.contract.minBidIncrement
      let percentIncrement = current->mul(minIncrementPercent)->div(fromString("100"))
      current->add(percentIncrement)
    }
  }

  let isDisabled =
    address->Nullable.toOption->Option.isNone ||
    !(auction.phase == Some(Active)) ||
    bidAmount == "" ||
    bidAmount->Viem.parseEther->Option.getWithDefault(BigInt.fromString("0")) < minBid ||
    balance->Nullable.toOption->Option.isNone ||
    balance
    ->Nullable.toOption
    ->Option.mapWithDefault(Some(BigInt.fromString("0")), balance => Some(balance.value)) <
      bidAmount->Viem.parseEther

  let {config} = Wagmi.usePrepareContractWrite(
    ~config={
      address: Environment.auctionContractAddress,
      abi: auctionContractAbi,
      functionName: "createBid",
      value: bidAmount->Viem.parseEther->Option.getWithDefault(BigInt.fromString("0")),
      args: [auction.tokenId],
      enabled: !isDisabled,
    },
  )

  let createBid = Wagmi.useContractWrite({
    ...config,
    onSuccess: _ => {
      setBidAmount(_ => "")
    },
  })

  let handleCreateBid = () =>
    switch createBid.write {
    | Some(createBid) => createBid()
    | None => raise(ContractWriteDoesNotExist)
    }

  <div
    className="flex flex-col lg:flex-row w-full lg:items-center justify-around gap-2 p-10 lg:p-0">
    <input
      className="flex-2 rounded-2xl px-2 py-4 placeholder:text-lg placeholder:font-bold
       bg-default-light border-background-dark
       lg:bg-secondary  focus:outline-none focus:ring-1 [appearance:textfield]
       [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
      placeholder={`Ξ ${Viem.formatEther(minBid)} or more`}
      step=0.1
      type_="number"
      value={bidAmount}
      onInput={e => onBidChange(e)}
    />
    <button
      className="flex-1 rounded-lg bg-active px-4 py-3 lg:px-3 lg:py-2 text-center text-white disabled:bg-default-disabled disabled:text-background-light text-xl lg:text-lg font-bold"
      disabled={isDisabled}
      onClick={_ => handleCreateBid()}>
      {"Place Bid"->React.string}
    </button>
  </div>
}
