@val @scope(("import", "meta", "env"))
external auctionContractAddress: option<string> = "VITE_AUCTION_CONTRACT_ADDRESS"
@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"
module AuctionCreatedFragment = %relay(`
  fragment AuctionCountdown_auctionCreated on AuctionCreated {
    endTime
  }
`)

let useInterval = (callback: unit => unit, delay) => {
  let savedCallback = React.useRef(() => ())

  // Remember the latest callback.
  React.useEffect1(() => {
    savedCallback.current = callback
    None
  }, [callback])

  // Set up the interval.
  React.useEffect1(() => {
    let tick = () => {
      savedCallback.current()
    }
    let id = setInterval(tick, delay)
    Some(() => clearInterval(id))
  }, [delay])
}

exception ContractWriteDoesNotExist
@react.component
let make = (~queryRef as auctionCreatedRef) => {
  let auctionCreated = AuctionCreatedFragment.use(auctionCreatedRef)
  let {config} = Wagmi.usePrepareContractWrite(
    ~config={
      address: auctionContractAddress->Belt.Option.getExn,
      abi: auctionContractAbi,
      functionName: "settleCurrentAndCreateNewAuction",
    },
  )
  let settleCurrentAndCreateNewAuction = Wagmi.useContractWrite(config)
  let handleSettleCurrentAndCreateNewAuction = _ =>
    switch settleCurrentAndCreateNewAuction.write {
    | Some(createBid) => createBid()
    | None => raise(ContractWriteDoesNotExist)
    }

  let endTime = auctionCreated.endTime->Float.fromString->Option.getExn

  let (secondsRemaining, setSecondsRemaining) = React.useState(_ =>
    (endTime -. Date.now() /. 1000.)->Float.toInt
  )

  useInterval(() => {
    if secondsRemaining > 0 {
      setSecondsRemaining(_ => secondsRemaining - 1)
    }
  }, 1000)

  let totalMinutesRemaining = secondsRemaining / 60
  let seconds = secondsRemaining->mod(60)->Int.toString
  let minutes = totalMinutesRemaining->mod(60)->Int.toString
  let hours = (totalMinutesRemaining / 60)->Int.toString

  <div className="flex lg:flex-col items-start justify-between">
    {secondsRemaining < 0
      ? <div className="w-full flex justify-center items-center">
          <button
            className="bg-primary-dark text-white font-bold py-2 px-4 rounded"
            onClick={handleSettleCurrentAndCreateNewAuction}>
            {"Start Next Auction"->React.string}
          </button>
        </div>
      : <>
          <p className="font-semibold text-xl text-background-dark lg:text-active">
            {"Time Left"->React.string}
          </p>
          <p className="font-bold text-xl lg:text-3xl text-default-darker">
            {`${hours}h
      ${minutes}m
      ${seconds}s`->React.string}
          </p>
        </>}
  </div>
}
