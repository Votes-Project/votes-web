@val @scope(("import", "meta", "env"))
external auctionContractAddress: option<string> = "VITE_AUCTION_CONTRACT_ADDRESS"
@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module AuctionItem = {
  module AuctionCreatedFragment = %relay(`
  fragment AuctionList_AuctionItem_auctionCreated on AuctionCreated {
    id
    tokenId
    startTime
    endTime
    ...CreateBid_auctionCreated
    ...AuctionCountdown_auctionCreated
  }
`)

  module AuctionSettledFragment = %relay(`
  fragment AuctionList_AuctionItem_auctionSettled on AuctionSettled {
    id
    tokenId
    winner
    amount
  }
  `)

  module VoteTransfersFragment = %relay(`
  fragment AuctionList_AuctionItem_voteTransfers on VoteTransfer {
    id
    tokenId
  }

`)

  exception ContractWriteDoesNotExist
  exception AuctionDoesNotExist
  @react.component
  let make = (
    ~index,
    ~auctionCreated as auctionCreatedRef=None,
    ~auctionSettled as auctionSettledRef=None,
    ~voteTransfer,
    ~setAuctionDate,
    ~children,
  ) => {
    let {setParams} = Routes.Main.Route.useQueryParams()
    let auctionCreated =
      auctionCreatedRef->Option.map(auctionCreatedRef =>
        AuctionCreatedFragment.use(auctionCreatedRef)
      )
    let auctionSettled =
      auctionSettledRef->Option.map(auctionSettledRef =>
        AuctionSettledFragment.use(auctionSettledRef)
      )
    let voteTransfer = VoteTransfersFragment.use(voteTransfer)
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

    React.useEffect2(() => {
      setAuctionDate(_ => auctionCreated->Option.map(({startTime}) => startTime))
      None
    }, (auctionCreated, setAuctionDate))

    let {todaysAuction, setTodaysAuction} = React.useContext(TodaysAuctionContext.context)

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

    React.useEffect3(() => {
      open TodaysAuctionContext
      switch (index, auctionCreated, voteTransfer) {
      | (0, Some({tokenId, startTime, endTime}), _) =>
        setTodaysAuction(_ =>
          todaysAuction->Option.mapWithDefault(
            Some({tokenId, startTime, endTime}),
            todaysAuction => Some({
              ...todaysAuction,
              tokenId,
              startTime,
              endTime,
            }),
          )
        )

      | (0, None, {tokenId}) =>
        setTodaysAuction(todaysAuction =>
          todaysAuction->Option.mapWithDefault(
            Some({tokenId, startTime: "raffle", endTime: "raffle"}),
            todaysAuction => Some({
              ...todaysAuction,
              tokenId,
              startTime: "raffle",
              endTime: "raffle",
            }),
          )
        )
      | _ => ()
      }
      None
    }, (auctionCreated, index, setTodaysAuction))

    let currentBid = switch todaysAuction {
    | Some(todaysAuction) => todaysAuction.currentBid->Option.getWithDefault("0")

    | _ => "Bid failed to load"
    }

    let isOver = {
      let endTime = auctionCreated->Option.flatMap(({endTime}) => endTime->Float.fromString)
      endTime->Option.map(endTime => endTime *. 1000. < Date.now())->Option.getWithDefault(false)
    }

    <>
      <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold text-default-darker ">
        {`VOTE ${voteTransfer.tokenId}`->React.string}
      </h1>
      {switch (index, auctionCreated, auctionSettled, isOver) {
      | (0, Some(auctionCreated), None, false) =>
        <>
          <div className="flex flex-col lg:flex-row gap-5">
            <div className="flex lg:flex-col items-start justify-between">
              <p className="font-semibold text-xl lg:text-active text-background-dark">
                {"Current Bid"->React.string}
              </p>
              <p className="font-bold text-xl lg:text-3xl text-default-darker">
                {"Ξ "->React.string}
                {currentBid->React.string}
              </p>
            </div>
            <div className="w-0 rounded-lg lg:border-primary border hidden lg:flex" />
            <AuctionCountdown queryRef={auctionCreated.fragmentRefs} />
          </div>
          <button
            className="flex flex-row gap-2 items-center justify-start pt-2"
            onClick={_ => setVoteDetails(Some(0))}>
            <ReactIcons.LuInfo size="1.25rem" className="text-default-darker" />
            <p className="text-md text-default-darker"> {"Ask your own question"->React.string} </p>
          </button>
          // <RescriptReactErrorBoundary
          //   fallback={_ => {<div> {React.string("Bid Component Failed to Insantiate")} </div>}}>
          <CreateBid queryRef=auctionCreated.fragmentRefs isToday={index == 0} />
          // </RescriptReactErrorBoundary>
          <ul className="flex flex-col justify-between py-4"> {children} </ul>
          <div className="w-full py-2 text-center pb-4">
            {currentBid == "0"
              ? React.null
              : <div
                  className="font-semibold text-background-dark hover:text-default-darker cursor-pointer">
                  {"View All Bids"->React.string}
                </div>}
          </div>
        </>
      | (0, None, None, _) => <div> {"Active Raffle"->React.string} </div>
      | (_, None, None, _) => <div> {"Past Raffle"->React.string} </div>

      | (_, _, Some(auctionSettled), true) =>
        <>
          <div>
            {"Winner:"->React.string}
            <ShortAddress address={Some(auctionSettled.winner)} />
          </div>
          <h2> {`Winning Bid: ${auctionSettled.amount} Ξ`->React.string} </h2>
        </>
      | (_, _, None, true) =>
        <>
          <button
            className="bg-primary-dark text-white font-bold py-2 px-4 rounded"
            onClick={handleSettleCurrentAndCreateNewAuction}>
            {"Start Next Auction"->React.string}
          </button>
        </>

      | _ => raise(AuctionDoesNotExist)
      }}
    </>
  }
}

module AuctionListDisplay = {
  module AuctionCreatedsFragment = %relay(`
  fragment AuctionListDisplay_auctionCreateds on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 5 }
    orderBy: { type: "OrderBy_AuctionCreateds", defaultValue: tokenId }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
  ) {
    auctionCreateds(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
    ) @connection(key: "AuctionListDisplay_auctionCreateds_auctionCreateds") {
      edges {
        node {
          id
          tokenId
          endTime
          ...AuctionList_AuctionItem_auctionCreated
        }
      }
    }
  }
  `)
  module AuctionSettledsFragment = %relay(`
  fragment AuctionListDisplay_auctionSettleds on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 5 }
    orderBy: { type: "OrderBy_AuctionSettleds", defaultValue: tokenId }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
  ) {
    auctionSettleds(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
    ) @connection(key: "AuctionListDisplay_auctionSettleds_auctionSettleds") {
      edges {
        node {
          id
          tokenId
          ...AuctionList_AuctionItem_auctionSettled
        }
      }
    }
  }
  `)

  type auction = {
    index: int,
    auctionCreated: option<
      AuctionListDisplay_auctionCreateds_graphql.Types.fragment_auctionCreateds_edges_node,
    >,
    auctionSettled: option<
      AuctionListDisplay_auctionSettleds_graphql.Types.fragment_auctionSettleds_edges_node,
    >,
    voteTransfer: AuctionListDisplay_voteTransfers_graphql.Types.fragment_voteTransfers_edges_node,
  }

  module VoteTransfersFragment = %relay(`
  fragment AuctionListDisplay_voteTransfers on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 1000 }
    orderBy: { type: "OrderBy_Transfers", defaultValue: tokenId }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    where: {
      type: "Where_Transfers"
      defaultValue: { from: "0x0000000000000000000000000000000000000000" }
    }
  ) {
    voteTransfers(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
      where: $where
    ) @connection(key: "AuctionListDisplay_voteTransfers_voteTransfers") {
      edges {
        node {
          id
          tokenId
          ...AuctionList_AuctionItem_voteTransfers
        }
      }
    }
  }
  `)

  type auctionType = Auction(auction) | Raffle(auction) | FlashAuction(auction)
  exception NoData
  @react.component
  let make = (~query, ~children, ~tokenId, ~setAuctionDate) => {
    let {auctionCreateds} = AuctionCreatedsFragment.use(query)
    let {auctionSettleds} = AuctionSettledsFragment.use(query)
    let {voteTransfers} = VoteTransfersFragment.use(query)

    let (auctionCreatedNodes, auctionSettledNodes, voteTransferNodes) = (
      auctionCreateds->AuctionCreatedsFragment.getConnectionNodes,
      auctionSettleds->AuctionSettledsFragment.getConnectionNodes,
      voteTransfers->VoteTransfersFragment.getConnectionNodes,
    )
    let singleDigitTokenId = tokenId => tokenId->Int.fromString->Option.map(mod(_, 10))

    let auction =
      voteTransferNodes
      ->Array.mapWithIndex((voteTransfer, i) => (voteTransfer, i))
      ->Array.find(((voteTransfer, i)) => {
        tokenId->Option.mapWithDefault(i == 0, tokenId => tokenId == voteTransfer.tokenId)
      })
      ->Option.map(((voteTransfer, i)) =>
        switch (i, singleDigitTokenId(voteTransfer.tokenId)) {
        | (0, Some(0)) =>
          FlashAuction({
            index: i,
            auctionCreated: auctionCreatedNodes->Array.get(0),
            auctionSettled: auctionSettledNodes
            ->Array.get(0)
            ->Option.filter(auctionSettled => auctionSettled.tokenId == voteTransfer.tokenId),
            voteTransfer,
          })
        | (_, Some(5)) =>
          FlashAuction({
            index: i,
            auctionCreated: auctionCreatedNodes->Array.find(({tokenId}) =>
              tokenId == voteTransfer.tokenId
            ),
            auctionSettled: auctionSettledNodes->Array.find(({tokenId}) =>
              tokenId == voteTransfer.tokenId
            ),
            voteTransfer,
          })
        | (_, Some(9)) =>
          Raffle({
            index: i,
            auctionCreated: None,
            auctionSettled: None,
            voteTransfer,
          })
        | _ =>
          Auction({
            index: i,
            auctionCreated: auctionCreatedNodes->Array.find(({tokenId}) =>
              tokenId == voteTransfer.tokenId
            ),
            auctionSettled: auctionSettledNodes->Array.find(({tokenId}) =>
              tokenId == voteTransfer.tokenId
            ),
            voteTransfer,
          })
        }
      )
    switch auction {
    | Some(Auction(auction)) =>
      <RescriptReactErrorBoundary
        fallback={e => {
          Console.log(e)
          "Error"->React.string
        }}>
        <AuctionItem
          index=auction.index
          auctionCreated={auction.auctionCreated->Option.map(auctionCreated =>
            auctionCreated.fragmentRefs
          )}
          auctionSettled={auction.auctionSettled->Option.map(auctionSettled =>
            auctionSettled.fragmentRefs
          )}
          voteTransfer={auction.voteTransfer.fragmentRefs}
          key=auction.voteTransfer.id
          setAuctionDate>
          {children}
        </AuctionItem>
      </RescriptReactErrorBoundary>
    | Some(Raffle(auction)) =>
      <RescriptReactErrorBoundary
        fallback={e => {
          Console.log(e)
          "Error"->React.string
        }}>
        <AuctionItem
          index=auction.index
          auctionCreated={None}
          auctionSettled={None}
          voteTransfer={auction.voteTransfer.fragmentRefs}
          key=auction.voteTransfer.id
          setAuctionDate>
          {children}
        </AuctionItem>
      </RescriptReactErrorBoundary>
    | Some(FlashAuction(auction)) =>
      <RescriptReactErrorBoundary
        fallback={e => {
          Console.log(e)
          "Error"->React.string
        }}>
        <AuctionItem
          index=auction.index
          auctionCreated={auction.auctionCreated->Option.map(auctionCreated =>
            auctionCreated.fragmentRefs
          )}
          auctionSettled={auction.auctionSettled->Option.map(auctionSettled =>
            auctionSettled.fragmentRefs
          )}
          voteTransfer={auction.voteTransfer.fragmentRefs}
          key=auction.voteTransfer.id
          setAuctionDate>
          {children}
        </AuctionItem>
      </RescriptReactErrorBoundary>
    | None => raise(NoData)
    }
  }
}

module Query = %relay(`
  query AuctionListQuery {
    ...AuctionListDisplay_auctionCreateds
    ...AuctionListDisplay_auctionSettleds
    ...AuctionListDisplay_voteTransfers
  }
`)

@module("/assets/RadarChart.png")
external radarChart: string = "default"

type arrowPress = LeftPress | RightPress
@react.component @relay.deferredComponent
let make = (~queryRef, ~children, ~tokenId) => {
  let {push} = RelayRouter.Utils.useRouter()
  let data = Query.usePreloaded(~queryRef)
  let (auctionDate, setAuctionDate) = React.useState(() => None)

  let {todaysAuction} = React.useContext(TodaysAuctionContext.context)

  let todaysAuctionTokenId = todaysAuction->Option.flatMap(todaysAuction => todaysAuction.tokenId)
  let tokenId = switch (tokenId, todaysAuctionTokenId) {
  | (Some(tokenId), _) => Some(tokenId)
  | (None, Some(tokenId)) => Some(tokenId)
  | _ => None
  }

  let auctionDateLocale =
    auctionDate
    ->Option.flatMap(Float.fromString)
    ->Option.map(startTime => startTime *. 1000.)
    ->Option.map(todaysStartTime =>
      todaysStartTime
      ->Date.fromTime
      ->Date.toLocaleDateStringWithLocaleAndOptions("en-US", {dateStyle: #long})
    )

  let handleArrowPress = (direction, tokenId) => {
    switch (direction, tokenId) {
    | (LeftPress, Some(tokenId)) =>
      Routes.Main.Auction.Route.makeLink(
        ~tokenId=tokenId
        ->Int.fromString
        ->Option.mapWithDefault("", tokenId => (tokenId - 1)->Int.toString),
      )->push
    | (RightPress, Some(tokenId)) =>
      Routes.Main.Auction.Route.makeLink(
        ~tokenId=tokenId
        ->Int.fromString
        ->Option.mapWithDefault("", tokenId => (tokenId + 1)->Int.toString),
      )->push
    | _ => ()
    }
  }
  let handleQueuePress = () => {
    Routes.Main.Queue.Route.makeLink()->push
  }

  <div className=" w-full pt-4">
    <div
      className="lg:flex-[0_0_auto] lg:max-w-6xl m-auto flex flex-col lg:flex-row lg:justify-center lg:items-center flex-shrink-0 max-w-full">
      <div className="  lg:w-[50%] w-[80%] md:w-[70%] mx-3 md:mx-4 lg:mx-0 flex align-end ">
        <div className="self-end w-full">
          <div className="relative h-0 w-full pt-[100%]">
            <img className="absolute left-0 top-0  w-full align-middle " src={radarChart} />
          </div>
        </div>
      </div>
      <div
        className="min-h-[558px] lg:flex-[0_0_auto] w-full !self-end bg-white pr-[5%] pb-0 lg:bg-transparent lg:w-[50%] lg:pr-20 ">
        <React.Suspense
          fallback={<div className="flex-1"> {React.string("Loading Auctions...")} </div>}>
          <div className="!self-start px-4">
            <div className="flex items-center pt-5">
              <div className="flex gap-2 items-center">
                <button
                  disabled={tokenId->Option.equal(Some("0"), (a, b) => a == b)}
                  onClick={_ => handleArrowPress(LeftPress, tokenId)}
                  className="flex h-8 w-8 items-center justify-center rounded-full bg-background-dark lg:bg-primary-dark disabled:bg-default-disabled ">
                  <ReactIcons.LuArrowLeft color="white" />
                </button>
                <ReactTooltip anchorSelect="#queue-press" content="Open Question Queue" />
                <button
                  id="queue-press"
                  onClick={_ => handleQueuePress()}
                  className="flex h-8 w-8 items-center justify-center rounded-full lg:bg-primary-dark bg-background-dark disabled:bg-default-disabled disabled:opacity-50 ">
                  <ReactIcons.LuListOrdered color="white" />
                </button>
                <button
                  onClick={_ => handleArrowPress(RightPress, tokenId)}
                  disabled={todaysAuction
                  ->Option.map(todaysAuction => todaysAuction.tokenId)
                  ->Option.equal(Some(tokenId), (a, b) => a == b)}
                  className="flex h-8 w-8 items-center justify-center rounded-full lg:bg-primary-dark bg-background-dark disabled:bg-default-disabled disabled:opacity-50 ">
                  <ReactIcons.LuArrowRight color="white" />
                </button>
                <p className="font-semibold text-background-dark lg:text-active">
                  {auctionDateLocale->Option.getWithDefault("")->React.string}
                </p>
              </div>
            </div>
            <AuctionListDisplay query={data.fragmentRefs} tokenId setAuctionDate>
              {children}
            </AuctionListDisplay>
          </div>
        </React.Suspense>
      </div>
    </div>
  </div>
}
