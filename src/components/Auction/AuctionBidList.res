@val @scope(("import", "meta", "env"))
external auctionContractAddress: option<string> = "VITE_AUCTION_CONTRACT_ADDRESS"

@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module AuctionBidItem = {
  module AuctionBidItemFragment = %relay(`
  fragment AuctionBidList_AuctionBidItem_auctionBid on AuctionBid {
    id
    tokenId
    bidder
    amount
  }
`)
  @react.component
  let make = (~auctionBid as auctionBidRef, ~isCurrentBid) => {
    let {amount, bidder, id, tokenId} = AuctionBidItemFragment.use(auctionBidRef)
    let amount = amount->BigInt.fromString->Viem.formatUnits(18)

    let {setTodaysAuction} = React.useContext(TodaysAuctionContext.context)

    React.useEffect4(() => {
      if isCurrentBid {
        open TodaysAuctionContext
        setTodaysAuction(todaysAuction =>
          todaysAuction->Option.mapWithDefault(
            Some({currentBid: amount}),
            todaysAuction => Some({
              ...todaysAuction,
              currentBid: amount,
            }),
          )
        )
      } else {
        ()
      }
      None
    }, (isCurrentBid, tokenId, amount, setTodaysAuction))

    <li className="border-b p-3 border-background-dark" key=id>
      <div className=" font-semibold flex items-center justify-between">
        <ShortAddress address={Some(bidder)} />
        <div className="flex gap-2">
          <p> {`Ξ ${amount}`->React.string} </p>
          <p> {"🔗"->React.string} </p>
        </div>
      </div>
    </li>
  }
}

module AuctionBidListDisplay = {
  module AuctionBidsFragment = %relay(`
  fragment AuctionBidListDisplay_auctionBids on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 1000 }
    orderBy: { type: "OrderBy_AuctionBids", defaultValue: tokenId }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
  ) {
    auctionBids(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
    ) @connection(key: "AuctionBidListDisplay_auctionBids_auctionBids") {
      __id
      edges {
        __id
        node {
          id
          tokenId
          amount
          ...AuctionBidList_AuctionBidItem_auctionBid
        }
      }
    }
  }
  `)
  @react.component
  let make = (~bids) => {
    let {queryParams} = Routes.Main.Vote.Bids.Route.useQueryParams()
    let {todaysAuction} = React.useContext(TodaysAuctionContext.context)

    let {auctionBids} = AuctionBidsFragment.use(bids)
    let environment = RescriptRelay.useEnvironmentFromContext()

    Wagmi.UseContractEvent.make({
      address: auctionContractAddress->Belt.Option.getExn,
      abi: auctionContractAbi,
      eventName: "AuctionBid",
      listener: events => {
        switch events {
        | [] => ()
        | events => {
            let event = events->Array.get(events->Array.length - 1)->Option.getExn
            let {args, transactionHash, logIndex} = event
            auctionBids->Option.mapWithDefault((), auctionBids => {
              open RescriptRelay
              let connectionId = auctionBids.__id
              commitLocalUpdate(~environment, ~updater=store => {
                open AuctionBidList_AuctionBidItem_auctionBid_graphql.Types
                open RecordSourceSelectorProxy
                open RecordProxy
                let connectionRecord = switch store->get(~dataId=connectionId) {
                | Some(connectionRecord) => connectionRecord
                | None => store->create(~dataId=connectionId, ~typeName="AuctionBidConnection")
                }

                let newAuctionBidRecord =
                  store
                  ->create(
                    ~dataId=`client:new_auctionBid:${transactionHash}${logIndex->Int.toString}}`->makeDataId,
                    ~typeName="AuctionBid",
                  )
                  ->setValueString(
                    ~name="id",
                    ~value=`${transactionHash}${logIndex->Int.toString}}`, // logIndex needs to be converted to a little endian I32. Probably okay though
                  )
                  ->setValueString(~name="tokenId", ~value=args.tokenId)
                  ->setValueString(~name="bidder", ~value=args.bidder)
                  ->setValueString(~name="amount", ~value=args.amount)

                let newEdge = ConnectionHandler.createEdge(
                  ~store,
                  ~connection=connectionRecord,
                  ~edgeType="AuctionBid",
                  ~node=newAuctionBidRecord,
                )

                ConnectionHandler.insertEdgeBefore(~connection=connectionRecord, ~newEdge)
              })
            })
          }
        }
      },
    })

    // let groupedBids = Dict.make()

    // auctionBids
    // ->AuctionBidsFragment.getConnectionNodes
    // ->Array.forEach(auctionBid => {
    //   let bidsByTokenId = groupedBids->Dict.get(auctionBid.tokenId)->Option.getWithDefault(list{})
    //   groupedBids->Dict.set(auctionBid.tokenId, list{...bidsByTokenId, auctionBid})
    // })

    // let sortBids = (
    //   bids: list<AuctionBidListDisplay_auctionBids_graphql.Types.fragment_auctionBids_edges_node>,
    // ) =>
    //   bids->List.sort((a, b) => {
    //     BigInt.fromString(a.amount) > b.amount->BigInt.fromString ? -1.0 : 1.0
    //   })

    // groupedBids
    // ->Dict.get(tokenId)
    // ->Option.mapWithDefault(list{}, sortBids)
    // ->List.mapWithIndex((i, auctionBid) => {
    //   <AuctionBidItem
    //     auctionBid={auctionBid.fragmentRefs}
    //     key=auctionBid.id
    //     isCurrentBid={i == 0 &&
    //       todaysAuction->Option.mapWithDefault(false, todaysAuction =>
    //         todaysAuction.tokenId == Some(auctionBid.tokenId)
    //       )}
    //   />
    // })
    // ->List.toArray
    // ->Array.slice(~start=0, ~end=3)
    []->React.array
  }
}

module Query = %relay(`
  query AuctionBidListQuery @raw_response_type {
    ...AuctionBidListDisplay_auctionBids
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)

  <React.Suspense fallback={<div> {React.string("Loading Auction Bids...")} </div>}>
    <AuctionBidListDisplay bids={data.fragmentRefs} />
  </React.Suspense>
}
