@val @scope(("import", "meta", "env"))
external auctionContractAddress: option<string> = "VITE_AUCTION_CONTRACT_ADDRESS"
@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module Query = %relay(`
  query MainQuery($voteContract: String!) {
    ...MainFragment @arguments(voteContract: $voteContract)
    ...HeaderFragment
  }
`)

module Fragment = %relay(`
  fragment MainFragment on Query
  @argumentDefinitions(voteContract: { type: "String!" }) {
    votes(orderBy: id, orderDirection: desc, first: 1000)
      @connection(key: "Main_votes_votes") {
      __id
      edges {
        node {
          id
          tokenId
          ...SingleVote_node @arguments(voteContractAddress: $voteContract)
        }
      }
    }
  }`)

@react.component @relay.deferredComponent
let make = (~children, ~queryRef) => {
  open FramerMotion

  let activeSubRoute = Routes.Main.Route.useActiveSubRoute()

  let {fragmentRefs} = Query.usePreloaded(~queryRef)
  let {votes} = Fragment.use(fragmentRefs)

  let newestVote = votes->Fragment.getConnectionNodes->Array.get(0)

  let newestTokenId = newestVote->Option.map(({tokenId}) => tokenId)->Option.getExn
  let environment = RescriptRelay.useEnvironmentFromContext()
  Wagmi.UseContractEvent.make({
    address: auctionContractAddress->Belt.Option.getExn,
    abi: auctionContractAbi,
    eventName: "AuctionCreated",
    listener: events => {
      switch events {
      | [] => ()
      | events => {
          let event = events->Array.get(events->Array.length - 1)->Option.getExn
          let {args} = event

          open RescriptRelay
          let connectionId = votes.__id
          commitLocalUpdate(~environment, ~updater=store => {
            open AuctionCreated
            open RecordSourceSelectorProxy
            open RecordProxy
            let connectionRecord = switch store->get(~dataId=connectionId) {
            | Some(connectionRecord) => connectionRecord
            | None => store->create(~dataId=connectionId, ~typeName="VotesConnection")
            }

            let id = args.tokenId->Helpers.tokenToSubgraphId->Option.getExn

            let newVoteRecord =
              store
              ->create(~dataId=`client:new_vote:${id}`->makeDataId, ~typeName="Vote")
              ->setValueString(~name="id", ~value=id)
              ->setValueString(~name="tokenId", ~value=args.tokenId)
              ->setValueString(~name="startTime", ~value=args.startTime)
              ->setValueString(~name="endTime", ~value=args.endTime)

            let newEdge = ConnectionHandler.createEdge(
              ~store,
              ~connection=connectionRecord,
              ~edgeType="Vote",
              ~node=newVoteRecord,
            )

            ConnectionHandler.insertEdgeBefore(~connection=connectionRecord, ~newEdge)
          })
        }
      }
    },
  })

  <>
    <div className="relative w-full h-full flex flex-col z-0">
      <Motion.Div
        layoutId="background-noise"
        className="wrapper absolute h-full w-full bg-primary noise flex flex-col z-[-1]"
      />
      <Header verifications=fragmentRefs />
      <main>
        <div className=" w-full pt-4">
          <div
            className="lg:flex-[0_0_auto] lg:max-w-6xl m-auto flex flex-col lg:flex-row lg:justify-center lg:items-center flex-shrink-0 max-w-full">
            <div
              className="self-end lg:w-[50%] w-[80%] md:w-[70%] mx-[10%] mt-8 md:mx-[15%] lg:mx-0 flex align-end ">
              <div className="relative h-0 w-full pt-[100%]">
                <EmptyVoteChart className="absolute left-0 top-0 w-full align-middle " />
              </div>
            </div>
            <div
              className="pt-[5%] px-[5%] lg:pr-20 lg:pl-0 lg:pt-0 min-h-[558px] lg:flex-[0_0_auto] w-full !self-end bg-white pr-[5%] pb-0 lg:bg-transparent lg:w-[50%]  ">
              <ErrorBoundary fallback={({error}) => {error->React.string}}>
                <React.Suspense fallback={<div />}>
                  {switch (newestVote, activeSubRoute) {
                  | (_, Some(_)) => children
                  | (Some({fragmentRefs}), None) =>
                    <SingleVote vote=fragmentRefs tokenId={newestTokenId} />
                  | _ => <div />
                  }}
                </React.Suspense>
              </ErrorBoundary>
            </div>
          </div>
        </div>
      </main>
      <DailyQuestionPreview />
      <div className="bg-default w-full relative">
        <VotesInfo />
      </div>
    </div>
  </>
}
