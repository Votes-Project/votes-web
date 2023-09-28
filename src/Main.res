module Query = %relay(`
  query MainQuery($voteContract: String!) {
    ...MainFragment @arguments(voteContract: $voteContract)
  }
`)

module Fragment = %relay(`
  fragment MainFragment on Query
  @argumentDefinitions(voteContract: { type: "String!" }) {
    votes(orderBy: id, orderDirection: desc, first: 1000)
      @connection(key: "Main_votes_votes") {
      edges {
        node {
          id
          tokenId
          owner
          auction {
            ...AuctionDisplay_auction
          }
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

  let newestTokenId = newestVote->Option.flatMap(({tokenId}) => tokenId->Int.fromString)

  <>
    <div className="relative w-full h-full flex flex-col z-0">
      <Motion.Div
        layoutId="background-noise"
        className="wrapper absolute h-full w-full bg-primary noise flex flex-col z-[-1]"
      />
      <Header />
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
              <React.Suspense fallback={<div />}>
                {switch (newestVote, activeSubRoute) {
                | (_, Some(_)) => children
                | (Some({fragmentRefs}), None) =>
                  <SingleVote vote=fragmentRefs tokenId={newestTokenId} />
                | _ => <div />
                }}
              </React.Suspense>
            </div>
          </div>
        </div>
      </main>
      <DailyQuestionSpeedDial />
      <div className="bg-background w-full relative">
        <VotesInfo />
      </div>
    </div>
  </>
}
