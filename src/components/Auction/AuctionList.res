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

  exception PastAuctionDoesNotExist
  @react.component
  let make = (
    ~auctionCreated as auctionCreatedRef,
    ~children,
    ~isToday=false,
    ~isSettled=true,
    ~auctionSettled as auctionSettledRef=None,
  ) => {
    let auctionCreated = AuctionCreatedFragment.use(auctionCreatedRef)
    let auctionSettled =
      auctionSettledRef->Option.map(auctionSettledRef =>
        AuctionSettledFragment.use(auctionSettledRef)
      )

    let {todaysAuction, setTodaysAuction} = React.useContext(TodaysAuctionContext.context)

    React.useEffect3(() => {
      let {tokenId, startTime, endTime} = auctionCreated
      if isToday {
        open TodaysAuctionContext
        setTodaysAuction(todaysAuction =>
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
      } else {
        ()
      }
      None
    }, (auctionCreated, isToday, setTodaysAuction))

    let currentBid = switch todaysAuction {
    | Some(todaysAuction) => todaysAuction.currentBid->Option.getWithDefault("0")

    | _ => "Bid failed to load"
    }

    switch isToday && auctionSettled->Option.isNone {
    | true =>
      <>
        <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold lg:text-7xl">
          {`VOTE ${auctionCreated.tokenId}`->React.string}
        </h1>
        <div className="flex flex-col ">
          <div className="flex items-center justify-between">
            <p> {"Current Bid"->React.string} </p>
            <p>
              {"Ξ "->React.string}
              {currentBid->React.string}
            </p>
          </div>
          <AuctionCountdown queryRef={auctionCreated.fragmentRefs} />
        </div>
        // <RescriptReactErrorBoundary
        //   fallback={_ => {<div> {React.string("Bid Component Failed to Insantiate")} </div>}}>
        <CreateBid queryRef=auctionCreated.fragmentRefs isToday />
        // </RescriptReactErrorBoundary>
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

  @react.component
  let make = (~query, ~children, ~tokenId) => {
    let {auctionCreateds} = AuctionCreatedsFragment.use(query)
    let {auctionSettleds} = AuctionSettledsFragment.use(query)

    let isTodaySettled = {
      let latestAuctionTokenId =
        auctionCreateds
        ->AuctionCreatedsFragment.getConnectionNodes
        ->Array.get(0)
        ->Option.map(({tokenId}) => tokenId)
      let latestSettledAuctionTokenId =
        auctionSettleds
        ->AuctionSettledsFragment.getConnectionNodes
        ->Array.get(0)
        ->Option.map(({tokenId}) => tokenId)

      latestAuctionTokenId->Option.equal(latestSettledAuctionTokenId, (a, b) => a == b)
    }

    let (todaysAuctionCreatedFragment, todaysAuctionSettledFragment) = isTodaySettled
      ? (
          auctionCreateds->AuctionCreatedsFragment.getConnectionNodes->Array.get(0),
          auctionSettleds->AuctionSettledsFragment.getConnectionNodes->Array.get(0),
        )
      : (auctionCreateds->AuctionCreatedsFragment.getConnectionNodes->Array.get(0), None)

    let auctionFragments = {
      let auctionCreatedNodes = isTodaySettled
        ? auctionCreateds->AuctionCreatedsFragment.getConnectionNodes
        : auctionCreateds->AuctionCreatedsFragment.getConnectionNodes->Array.sliceToEnd(~start=1)
      Belt.Array.zip(
        auctionCreatedNodes,
        auctionSettleds->AuctionSettledsFragment.getConnectionNodes,
      )
    }

    let handleTodaysAuction = (
      auctionCreatedFragment: option<
        AuctionListDisplay_auctionCreateds_graphql.Types.fragment_auctionCreateds_edges_node,
      >,
      auctionSettledFragment: option<
        AuctionListDisplay_auctionSettleds_graphql.Types.fragment_auctionSettleds_edges_node,
      >,
    ) =>
      switch (auctionCreatedFragment, auctionSettledFragment) {
      | (Some(auctionCreated), Some(auctionSettled)) =>
        <AuctionItem
          auctionCreated={auctionCreated.fragmentRefs}
          auctionSettled={auctionSettled.fragmentRefs->Some}
          key=auctionCreated.id
          isToday=true>
          {children}
        </AuctionItem>
      | (Some(auctionCreated), None) =>
        <AuctionItem
          auctionCreated={auctionCreated.fragmentRefs} key=auctionCreated.id isToday=true>
          {children}
        </AuctionItem>
      | _ => <div> {"There are no auctions today"->React.string} </div>
      }

    let auctionItems = switch tokenId {
    | None => handleTodaysAuction(todaysAuctionCreatedFragment, todaysAuctionSettledFragment)
    | Some(tokenId) =>
      if (
        todaysAuctionCreatedFragment
        ->Option.map(todaysAuction => tokenId == todaysAuction.tokenId)
        ->Option.equal(Some(true), (a, b) => a == b)
      ) {
        handleTodaysAuction(todaysAuctionCreatedFragment, todaysAuctionSettledFragment)
      } else {
        auctionFragments
        ->Array.filter(((auctionCreated, _)) => tokenId == auctionCreated.tokenId)
        ->Array.map(((auctionCreated, auctionSettled)) => {
          <AuctionItem
            auctionCreated={auctionCreated.fragmentRefs}
            auctionSettled={Some(auctionSettled.fragmentRefs)}
            key=auctionCreated.id>
            {children}
          </AuctionItem>
        })
        ->React.array
      }
    }

    auctionItems
  }
}

%%raw(`
import viteLogo from "/vite.svg";
`)
module Query = %relay(`
  query AuctionListQuery {
    ...AuctionListDisplay_auctionCreateds
    ...AuctionListDisplay_auctionSettleds
  }
`)

type arrowDirection = LeftPress | RightPress
@react.component @relay.deferredComponent
let make = (~queryRef, ~children, ~tokenId) => {
  let {push} = RelayRouter.Utils.useRouter()
  let data = Query.usePreloaded(~queryRef)

  let {todaysAuction} = React.useContext(TodaysAuctionContext.context)

  let startTime = switch todaysAuction {
  | Some({startTime}) => startTime
  | _ => "Could not fetch auction date"
  }
  let todaysAuctionTokenId = todaysAuction->Option.flatMap(todaysAuction => todaysAuction.tokenId)
  let tokenId = switch (tokenId, todaysAuctionTokenId) {
  | (Some(tokenId), _) => Some(tokenId)
  | (None, Some(tokenId)) => Some(tokenId)
  | _ => None
  }

  let auctionDate =
    startTime
    ->Float.fromString
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

  <>
    <div className="flex flex-col bg-secondary lg:flex-row">
      <div className="mx-[10%) mt-8 w-[50%] self-end md:mx-[15%] md:w-[50%] lg:w-full">
        <div className="relative h-0 w-full pt-[100%]">
          <img
            className="absolute left-0 top-0 h-auto w-full align-middle " src={%raw("viteLogo")}
          />
        </div>
      </div>
      <div
        className="min-h-[558px] w-full !self-end bg-background pr-[5%] pb-0 lg:bg-secondary lg:pr-20 ">
        <div className="!self-start p-4">
          <div className="flex items-center pt-5">
            <div className="flex gap-2 items-center">
              <button
                disabled={tokenId->Option.equal(Some("0"), (a, b) => a == b)}
                onClick={_ => handleArrowPress(LeftPress, tokenId)}
                className="flex h-8 w-8 items-center justify-center rounded-full bg-primary ">
                {"⬅️"->React.string}
              </button>
              <button
                onClick={_ => handleArrowPress(RightPress, tokenId)}
                disabled={todaysAuction
                ->Option.map(todaysAuction => todaysAuction.tokenId)
                ->Option.equal(Some(tokenId), (a, b) => a == b)}
                className="flex h-8 w-8 items-center justify-center rounded-full bg-primary ">
                {"➡️"->React.string}
              </button>
              <p> {auctionDate->Option.getWithDefault("")->React.string} </p>
            </div>
          </div>
          <React.Suspense fallback={<div> {React.string("Loading Auctions...")} </div>}>
            <AuctionListDisplay query={data.fragmentRefs} tokenId> {children} </AuctionListDisplay>
          </React.Suspense>
        </div>
      </div>
    </div>
  </>
}
