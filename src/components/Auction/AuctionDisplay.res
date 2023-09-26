@val @scope(("import", "meta", "env"))
external auctionContractAddress: option<string> = "VITE_AUCTION_CONTRACT_ADDRESS"
@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module Fragment = %relay(`
  fragment AuctionDisplay_auction on Auction {
    id
    startTime
    endTime
    bidder
    settled
    vote {
      tokenId
    }
    amount
    ...CreateBid_auction
    ...AuctionCountdown_auction
  }
  `)

exception ContractWriteDoesNotExist
exception AuctionDoesNotExist
type arrowPress = LeftPress | RightPress
@react.component
let make = (
  ~auction: option<RescriptRelay.fragmentRefs<[#AuctionDisplay_auction]>>,
  ~owner,
  ~children,
) => {
  let {push} = RelayRouter.Utils.useRouter()
  let (auctionDate, setAuctionDate) = React.useState(() => None)
  let auction = auction->Option.map(auction => Fragment.use(auction))
  switch auction {
  | None => "Raffle"->React.string
  | Some(auction) =>
    let tokenId = auction.vote.tokenId
    let startTimeMs =
      auction.startTime->Float.fromString->Option.mapWithDefault(0., x => x *. 1000.)
    let endTimeMs = auction.endTime->Float.fromString->Option.mapWithDefault(0., x => x *. 1000.)

    let (isToday, _) = React.useState(() => startTimeMs < Date.now() && endTimeMs > Date.now())

    let {setParams} = Routes.Main.Route.useQueryParams()
    let {setParams: setBidsParams} = Routes.Main.Vote.Bids.Route.useQueryParams()

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

    let setVoteDetails = voteDetails => {
      setParams(
        ~removeNotControlledParams=false,
        ~navigationMode_=Push,
        ~shallow=false,
        ~setter=c => {
          ...c,
          voteDetails,
        },
      )
    }

    let handleAllBids = _ => {
      setBidsParams(
        ~removeNotControlledParams=false,
        ~navigationMode_=Push,
        ~shallow=false,
        ~setter=c => {
          ...c,
          allBids: Some(0),
        },
      )
    }

    <>
      <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold text-default-darker ">
        {`VOTE ${tokenId}`->React.string}
      </h1>
      {switch (isToday, auction) {
      | (true, {settled: false, fragmentRefs}) =>
        <>
          <div className="flex flex-col lg:flex-row gap-2 lg:gap-5">
            <div className="flex lg:flex-col items-start justify-between">
              <p className="font-semibold text-xl lg:text-active text-background-dark">
                {"Current Bid"->React.string}
              </p>
              <p className="font-bold text-xl lg:text-3xl text-default-darker">
                {"Ξ "->React.string}
                {auction.amount->React.string}
              </p>
            </div>
            <div className="w-0 rounded-lg lg:border-primary border hidden lg:flex" />
            <AuctionCountdown auction={fragmentRefs} />
          </div>
          <button
            className="flex flex-row gap-2 items-center justify-start pt-2"
            onClick={_ => setVoteDetails(Some(0))}>
            <ReactIcons.LuInfo size="1.25rem" className="text-default-darker" />
            <p className="text-md text-default-darker py-4">
              {"Ask your own question"->React.string}
            </p>
          </button>
          <ErrorBoundary
            fallback={_ => {<div> {React.string("Bid Component Failed to Insantiate")} </div>}}>
            <CreateBid auction=fragmentRefs isToday />
          </ErrorBoundary>
          <ul className="flex flex-col justify-between py-4"> {children} </ul>
          <div className="w-full py-2 text-center pb-4">
            {auction.amount == "0"
              ? React.null
              : <div
                  onClick={handleAllBids}
                  className="font-semibold text-background-dark hover:text-default-darker cursor-pointer">
                  {"View All Bids"->React.string}
                </div>}
          </div>
        </>
      | (false, {settled: false}) =>
        <>
          <button
            className="bg-primary-dark text-white font-bold py-2 px-4 rounded"
            onClick={handleSettleCurrentAndCreateNewAuction}>
            {"Start Next Auction"->React.string}
          </button>
        </>

      | (false, {settled: true, amount, bidder}) =>
        <>
          <div className="flex flex-col lg:flex-row lg:gap-5 gap-2">
            <div className="flex lg:flex-col items-start justify-between">
              <p className="font-medium text-xl lg:text-active text-background-dark">
                {"Winning Bid"->React.string}
              </p>
              <p className="font-bold text-xl lg:text-3xl text-default-darker">
                {"Ξ "->React.string}
                {amount->BigInt.fromString->Viem.formatUnits(18)->React.string}
              </p>
            </div>
            <div className="w-0 rounded-lg lg:border-primary border hidden lg:flex" />
            <div className="flex lg:flex-col items-start justify-between">
              {<>
                <p className="font-medium text-xl text-background-dark lg:text-active">
                  {"Held By"->React.string}
                </p>
                <p className="font-bold text-xl lg:text-3xl text-default-darker">
                  <ShortAddress address={Some(owner)} />
                </p>
              </>}
            </div>
          </div>
          <button
            className="flex flex-row gap-2 items-center justify-start pt-2"
            onClick={_ => setVoteDetails(Some(0))}>
            <ReactIcons.LuInfo size="1.25rem" className="text-default-darker" />
            <p className="text-md text-default-darker py-4">
              {"Ask your own question"->React.string}
            </p>
          </button>
          <div className="flex pb-4 flex-col gap-2 justify-between text-default-darker">
            <p>
              {`Winner `->React.string}
              <React.Suspense fallback={<> </>}>
                <a href="">
                  <ShortAddress address={bidder} />
                </a>
              </React.Suspense>
            </p>
            <p> {`Question Not Used`->React.string} </p>
            <p>
              {`Asker `->React.string}
              <a href=""> {"N/A"->React.string} </a>
            </p>
          </div>
          <div className="flex py-4 gap-4">
            <button
              onClick={handleAllBids}
              className=" lg:bg-primary font-semibold text-default-darker hover:bg-background-light p-2 bg-background rounded-md transition-colors">
              {"Bid History"->React.string}
            </button>
            <button
              className=" lg:bg-primary font-semibold text-default-darker hover:bg-background-light p-2 bg-background rounded-md transition-colors">
              {"Etherscan"->React.string}
            </button>
          </div>
        </>

      | _ => raise(AuctionDoesNotExist)
      }}
    </>
  }
}
