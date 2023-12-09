RescriptRelay.relayFeatureFlags.enableRelayResolvers = true

@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module SettleAuctionButton = {
  exception SettleAuctionWriteDoesNotExist
  @react.component
  let make = (~isSettled) => {
    let {config} = Wagmi.usePrepareContractWrite(
      ~config={
        address: Environment.auctionContractAddress,
        abi: auctionContractAbi,
        functionName: "settleCurrentAndCreateNewAuction",
        enabled: !isSettled,
      },
    )
    let settleCurrentAndCreateNewAuction = Wagmi.useContractWrite(config)
    let handleSettleCurrentAndCreateNewAuction = _ =>
      switch settleCurrentAndCreateNewAuction.write {
      | Some(createBid) => createBid()
      | None => raise(SettleAuctionWriteDoesNotExist)
      }
    switch isSettled {
    | true => <> </>
    | false =>
      <div className="p-4">
        <button
          className="bg-default-dark lg:bg-primary-dark text-white font-bold py-2 px-4 rounded w-full"
          onClick={handleSettleCurrentAndCreateNewAuction}>
          {"Start Next Auction"->React.string}
        </button>
      </div>
    }
  }
}

module BlockExplorerButton = {
  module Fragment = %relay(`
  fragment AuctionDisplay_BlockExplorerButton_auction on Auction {
    id
    tokenId
    contract {
      votesToken
    }
  }
  `)
  @react.component
  let make = (~auction) => {
    let auction = Fragment.use(auction)
    let {chain, chains} = Wagmi.Network.use()

    let chainBlockExplorer = switch chain->Nullable.toOption {
    | None =>
      chains
      ->Array.findMap(chain => chain.id == 1 ? Some(chain) : None)
      ->Option.flatMap(chain => chain.blockExplorers->Dict.get("default"))
    | Some({blockExplorers}) => blockExplorers->Dict.get("default")
    }

    switch chainBlockExplorer {
    | Some({name, url}) =>
      <a
        href={url ++ `/token/${auction.contract.votesToken}?a=${auction.tokenId->BigInt.toString}`}
        target="_blank"
        rel="noopener noreferrer">
        <button
          className=" lg:bg-primary font-semibold text-default-darker hover:bg-default-light p-2 bg-default rounded-md transition-colors">
          {name->React.string}
        </button>
      </a>
    | None => <> </>
    }
  }
}

module Fragment = %relay(`
  fragment AuctionDisplay_auction on Auction {
    id
    tokenId
    bidder
    settled
    amount
    phase
    ...CreateBid_auction
    ...AuctionCountdown_auction
    ...AuctionCurrentBid_auction
    ...AuctionBidList_auction
    ...AllBidsList_auction
    ...AuctionDisplay_BlockExplorerButton_auction
  }
  `)

module AskQuestionLink = {
  @react.component
  let make = (~children) => {
    <RelayRouter.Link to_={Routes.Main.Question.Ask.Route.makeLink()}>
      {children}
    </RelayRouter.Link>
  }
}

exception AuctionDoesNotExist
type arrowPress = LeftPress | RightPress
@react.component
let make = (~auction, ~owner) => {
  let auction = Fragment.use(auction)
  let phase = auction.phase

  let {
    setParams: setAuctionParams,
    queryParams: {showAllBids},
  } = Routes.Main.Vote.Auction.Route.useQueryParams()

  let handleShowAllBids = _ => {
    setAuctionParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=true,
      ~setter=c => {
        ...c,
        showAllBids: Some(0),
      },
    )
  }

  <>
    <h1 className=" py-9 text-6xl text-default-darker ">
      {`VOTE ${auction.tokenId->BigInt.toString}`->React.string}
    </h1>
    {switch (phase, auction) {
    | (Some(Before), _) => <> {"Auction has not started yet"->React.string} </>
    | (Some(Active), {settled: false, fragmentRefs}) =>
      <>
        <div className="flex flex-col lg:flex-row gap-2 lg:gap-5">
          <AuctionCurrentBid auction={fragmentRefs} />
          <div className="w-0 rounded-lg lg:border-primary border hidden lg:flex" />
          <AuctionCountdown auction={fragmentRefs} />
        </div>
        <div className="flex w-full">
          <AskQuestionLink>
            <div className="flex flex-row gap-2 items-center justify-start">
              <ReactIcons.LuInfo size="1.25rem" className="text-default-darker" />
              <p className="text-md text-default-darker py-4">
                {"Ask your own question"->React.string}
              </p>
            </div>
          </AskQuestionLink>
        </div>
        <ErrorBoundary
          fallback={_ => {<div> {React.string("Bid Component Failed to Insantiate")} </div>}}>
          <OpenConnectModalWrapper>
            <CreateBid auction=fragmentRefs />
          </OpenConnectModalWrapper>
        </ErrorBoundary>
        <ul className="flex flex-col justify-between py-4">
          <AuctionBidList bids={auction.fragmentRefs} />
        </ul>
        <div className="w-full py-2 text-center pb-4">
          {auction.bidder->Option.mapWithDefault(React.null, _ =>
            <button
              type_="button"
              onClick={handleShowAllBids}
              className="font-semibold  hover:text-default-darker cursor-pointer">
              {"View All Bids"->React.string}
            </button>
          )}
        </div>
        <AllBidsListModal isOpen={showAllBids->Option.isSome}>
          <AllBidsList bids={auction.fragmentRefs} />
        </AllBidsListModal>
      </>

    | (Some(After), {settled, amount, bidder}) =>
      <>
        <div className="flex flex-col lg:flex-row lg:gap-5 gap-2">
          <div className="flex lg:flex-col items-start justify-between">
            <p className="font-medium text-xl lg:text-active text-background-dark">
              {"Winning Bid"->React.string}
            </p>
            <p className="font-bold text-xl lg:text-3xl text-default-darker">
              {"Ξ "->React.string}
              {amount->Viem.formatUnits(18)->React.string}
            </p>
          </div>
          <div className="w-0 rounded-lg lg:border-primary border hidden lg:flex" />
          <div className="flex lg:flex-col items-start justify-between">
            <p className="font-medium text-xl text-background-dark lg:text-active">
              {"Held By"->React.string}
            </p>
            <p className="font-bold text-xl lg:text-3xl text-default-darker">
              <ShortAddress address={Some(owner)} />
            </p>
          </div>
        </div>
        <OpenConnectModalWrapper>
          <SettleAuctionButton isSettled=settled />
        </OpenConnectModalWrapper>
        <div className="flex w-full">
          <AskQuestionLink>
            <div className="flex flex-row gap-2 items-center justify-start">
              <ReactIcons.LuInfo size="1.25rem" className="text-default-darker" />
              <p className="text-md text-default-darker py-4">
                {"Ask your own question"->React.string}
              </p>
            </div>
          </AskQuestionLink>
        </div>
        <div className="flex pb-4 flex-col gap-2 justify-between text-default-darker">
          <div className="flex flex-row gap-2 items-center justify-start pt-2 font-semibold">
            <ReactIcons.LuHeart />
            <p className="">
              {`Winner `->React.string}
              <React.Suspense fallback={<> </>}>
                <a href="">
                  <ShortAddress address={bidder} />
                </a>
              </React.Suspense>
            </p>
          </div>
          <p> {`Question Not Used`->React.string} </p>
          <p>
            {`Asker `->React.string}
            <a href=""> {"N/A"->React.string} </a>
          </p>
        </div>
        <div className="flex py-4 gap-4">
          <button
            onClick={handleShowAllBids}
            className=" lg:bg-primary font-semibold text-default-darker hover:bg-default-light p-2 bg-default rounded-md transition-colors">
            {"Bid History"->React.string}
          </button>
          <BlockExplorerButton auction={auction.fragmentRefs} />
        </div>
        <AllBidsListModal isOpen={showAllBids->Option.isSome}>
          <AllBidsList bids={auction.fragmentRefs} />
        </AllBidsListModal>
      </>

    | _ => <> </>
    }}
  </>
}
