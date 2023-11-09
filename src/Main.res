@val @scope(("import", "meta", "env"))
external auctionContractAddress: option<string> = "VITE_AUCTION_CONTRACT_ADDRESS"
@val @scope(("import", "meta", "env"))
external voteContractAddress: option<string> = "VITE_VOTES_CONTRACT_ADDRESS"
@module("/src/abis/Auction.json") external auctionContractAbi: JSON.t = "default"

module Query = %relay(`
  query MainQuery($voteContractAddress: String!) {
    ...MainFragment
    ...HeaderFragment
    voteContract(id: $voteContractAddress) {
      ...QuestionPreview_voteContract
      ...BottomNav_voteContract
    }
  }
`)

module Fragment = %relay(`
  fragment MainFragment on Query {
    votes(orderBy: id, orderDirection: desc, first: 1000)
      @connection(key: "Main_votes_votes") {
      __id
      edges {
        node {
          id
          auction {
            tokenId
            startTime
            ...BottomNav_auction
          }
          ...SingleVote_node
        }
      }
    }
    randomQuestion {
      id
      question
      options
      ...SingleQuestion_node
      ...BottomNav_question
    }
  }`)

@react.component @relay.deferredComponent
let make = (~children, ~queryRef) => {
  open FramerMotion
  let {fragmentRefs, voteContract} = Query.usePreloaded(~queryRef)
  let {votes, randomQuestion} = Fragment.use(fragmentRefs)

  let {heroComponent} = React.useContext(HeroComponentContext.context)
  let {setAuction, setIsLoading: setIsAuctionLoading} = React.useContext(AuctionContext.context)
  let {setVote} = React.useContext(VoteContext.context)
  let {setQuestion} = React.useContext(QuestionContext.context)

  let newestVote = votes->Fragment.getConnectionNodes->Array.get(0)

  React.useEffect0(() => {
    switch newestVote {
    | Some(vote) => {
        setAuction(_ => vote.auction)
        setIsAuctionLoading(_ => false)
        setVote(_ => Some(vote.fragmentRefs))
        setQuestion(_ => randomQuestion->Option.map(q => q.fragmentRefs))
      }
    | _ => ()
    }
    None
  })

  // let environment = RescriptRelay.useEnvironmentFromContext()

  // Might cost too much money
  // Wagmi.UseContractEvent.make({
  //   address: auctionContractAddress->Belt.Option.getExn,
  //   abi: auctionContractAbi,
  //   eventName: "AuctionCreated",
  //   listener: events => {
  //     switch events {
  //     | [] => ()
  //     | events => {
  //         let event = events->Array.get(events->Array.length - 1)->Option.getExn
  //         let {args} = event

  //         open RescriptRelay
  //         let connectionId = votes.__id
  //         commitLocalUpdate(~environment, ~updater=store => {
  //           open AuctionCreated
  //           open RecordSourceSelectorProxy
  //           open RecordProxy
  //           let connectionRecord = switch store->get(~dataId=connectionId) {
  //           | Some(connectionRecord) => connectionRecord
  //           | None => store->create(~dataId=connectionId, ~typeName="VotesConnection")
  //           }

  //           let id = args.tokenId->Helpers.tokenToSubgraphId->Option.getExn

  //           let newAuctionRecord =
  //             store
  //             ->create(~dataId=`client:new_auction:${id}`->makeDataId, ~typeName="Auction")
  //             ->setValueString(~name="id", ~value=id)
  //             ->setValueString(~name="startTime", ~value=args.startTime)
  //             ->setValueString(~name="endTime", ~value=args.endTime)

  //           let voteContractAddress = voteContractAddress->Option.getWithDefault("0x0")
  //           let totalSupply = {
  //             open BigInt
  //             args.tokenId->fromString->add(1->fromInt)->toString
  //           }

  //           let newContractRecord =
  //             store
  //             ->create(
  //               ~dataId=`client:new_contract:${voteContractAddress}`->makeDataId,
  //               ~typeName="VoteContract",
  //             )
  //             ->setValueString(~name="id", ~value=voteContractAddress)
  //             ->setValueString(~name="totalSupply", ~value=totalSupply)

  //           let newVoteRecord =
  //             store
  //             ->create(~dataId=`client:new_vote:${id}`->makeDataId, ~typeName="Vote")
  //             ->setValueString(~name="id", ~value=id)
  //             ->setValueString(~name="tokenId", ~value=args.tokenId)
  //             ->setValueString(~name="startTime", ~value=args.startTime)
  //             ->setValueString(~name="endTime", ~value=args.endTime)
  //             ->setLinkedRecord(~record=newAuctionRecord, ~name="auction")
  //             ->setLinkedRecord(~record=newContractRecord, ~name="contract")

  //           let newEdge = ConnectionHandler.createEdge(
  //             ~store,
  //             ~connection=connectionRecord,
  //             ~edgeType="Vote",
  //             ~node=newVoteRecord,
  //           )

  //           ConnectionHandler.insertEdgeBefore(~connection=connectionRecord, ~newEdge)
  //         })
  //       }
  //     }
  //   },
  // })

  <>
    <div className="relative w-full h-full flex flex-col z-0">
      <Motion.Div
        layoutId="background-noise"
        className="fixed bg-primary noise animate-[grain_10s_steps(10)_infinite] flex flex-col z-[-1] w-[300%] h-[300%] left-[-50%] top-[-100%] overflow-hidden"
      />
      <Header verifications=fragmentRefs />
      <main>
        <div className="w-full pt-4">
          <div
            className="lg:flex-[0_0_auto] lg:max-w-6xl m-auto flex flex-col lg:flex-row  flex-shrink-0 max-w-full ">
            {heroComponent}
            <div
              className=" pt-[5%]  lg:pl-0 lg:pt-0 min-h-[558px] lg:flex-[0_0_auto] w-full bg-white pb-0 lg:bg-transparent lg:w-[50%]">
              <ErrorBoundary
                fallback={({error}) => {
                  error->JSON.stringifyAny->Option.getWithDefault("")->React.string
                }}>
                <React.Suspense fallback={<div />}> {children} </React.Suspense>
              </ErrorBoundary>
            </div>
          </div>
        </div>
      </main>
      <ErrorBoundary fallback={({error}) => error->JSON.stringifyAny->Option.getExn->React.string}>
        <React.Suspense fallback={<div />}>
          <BottomNav
            voteContract={voteContract->Option.map(c => c.fragmentRefs)}
            question={randomQuestion->Option.map(q => q.fragmentRefs)}
            auction={newestVote->Option.flatMap(v => v.auction)->Option.map(a => a.fragmentRefs)}
          />
        </React.Suspense>
      </ErrorBoundary>
      <div className="bg-default w-full relative">
        <VotesInfo />
      </div>
      <footer className="flex h-10  p-10 w-full bg-default" />
    </div>
  </>
}
