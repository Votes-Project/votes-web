@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module AuctionBidItem = {
  module Fragment = %relay(`
  fragment AuctionBidList_AuctionBidItem_auctionBid on AuctionBid {
    id
    tokenId
    bidder
    amount
  }
`)
  @react.component
  let make = (~bid) => {
    let {amount, bidder, id} = Fragment.use(bid)
    let amount = amount->Viem.formatUnits(18)

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

module Fragment = %relay(`
  fragment AuctionBidList_auction on Auction
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 1000 }
    orderBy: { type: "AuctionBid_orderBy", defaultValue: blockTimestamp }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
  ) {
    __id
    bids(orderBy: $orderBy, orderDirection: $orderDirection, first: $first) {
      id
      ...AuctionBidList_AuctionBidItem_auctionBid
    }
  }
  `)

exception NoAuctionId
exception NoBidsRecord
@react.component
let make = (~bids) => {
  let {bids, __id: auctionId} = Fragment.use(bids)

  let environment = RescriptRelay.useEnvironmentFromContext()

  Wagmi.UseContractEvent.make({
    address: Environment.auctionContractAddress,
    abi: auctionContractAbi,
    eventName: "AuctionBid",
    listener: events => {
      switch events {
      | [] => ()
      | events => {
          let event = events->Array.get(events->Array.length - 1)->Option.getExn
          let {args, transactionHash, logIndex} = event

          open RescriptRelay
          commitLocalUpdate(~environment, ~updater=store => {
            open AuctionBidList_AuctionBidItem_auctionBid_graphql.Types
            open RecordSourceSelectorProxy
            open RecordProxy
            let newAuctionBidRecord =
              store
              ->create(
                ~dataId=`client:new_auctionBid:${transactionHash}${logIndex->Int.toString}}`->makeDataId,
                ~typeName="AuctionBid",
              )
              ->setValueString(~name="id", ~value=`${transactionHash}${logIndex->Int.toString}}`) // logIndex needs to be converted to a little endian I32. Probably okay though
              ->setValueString(~name="tokenId", ~value=args.tokenId->BigInt.toString)
              ->setValueString(~name="bidder", ~value=args.bidder)
              ->setValueString(~name="amount", ~value=args.amount->BigInt.toString)
              ->Some

            let auctionRecord = switch store->get(~dataId=auctionId) {
            | Some(auctionRecord) => auctionRecord
            | None => raise(NoAuctionId)
            }

            let auctionBidsRecord = switch auctionRecord->getLinkedRecords(~name="bids") {
            | Some(bids) => bids
            | None => raise(NoBidsRecord)
            }

            let newBids = [newAuctionBidRecord]->Array.concat(auctionBidsRecord)

            let _ =
              auctionRecord
              ->setValueString(~name="amount", ~value=args.amount->BigInt.toString)
              ->setValueString(~name="bidder", ~value=args.bidder)
              ->setLinkedRecords(~name="bids", ~records=newBids)
          })
        }
      }
    },
  })

  bids
  ->Array.map(({id, fragmentRefs}) => {
    <AuctionBidItem bid=fragmentRefs key=id />
  })
  ->Array.slice(~start=0, ~end=3)
  ->React.array
}
