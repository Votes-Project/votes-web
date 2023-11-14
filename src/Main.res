module Query = %relay(`
  query MainQuery($voteContractAddress: String!, $contextId: String!) {
    ...MainFragment
    ...HeaderFragment
    voteContract(id: $voteContractAddress) {
      ...BottomNav_voteContract
    }
    verification(contextId: $contextId) {
      ... on VerificationData {
        id
        unique
      }
      ... on Error {
        error
      }
    }
  }
`)

module Fragment = %relay(`
  fragment MainFragment on Query {
    votes(orderBy: id, orderDirection: desc, first: 1000, after: "")
      @connection(key: "VotesConnection_votes") {
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
      ...SingleQuestion_node
      ...BottomNav_question
    }
  }`)

@react.component @relay.deferredComponent
let make = (~children, ~queryRef) => {
  open FramerMotion
  let {fragmentRefs, voteContract, verification} = Query.usePreloaded(~queryRef)

  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let isNarrow = width < 1024

  let handleWindowSizeChange = React.useCallback(() => {
    setWidth(_ => window->Window.innerWidth)
  })
  React.useEffect0(() => {
    window->Window.addEventListener(Resize, handleWindowSizeChange)

    Some(() => window->Window.removeEventListener(Resize, handleWindowSizeChange))
  })

  let {votes, randomQuestion} = Fragment.use(fragmentRefs)

  let {heroComponent} = React.useContext(HeroComponentContext.context)
  let {setAuction, setIsLoading: setIsAuctionLoading} = React.useContext(AuctionContext.context)
  let {setVote} = React.useContext(VoteContext.context)
  let {setQuestion} = React.useContext(QuestionContext.context)
  let {setVerification} = React.useContext(VerificationContext.context)

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

    setVerification(_ =>
      switch verification {
      | Error({error}) => VerificationContext.Error({error: error})->Some
      | VerificationData({id, unique}) => VerificationContext.Verification({id, unique})->Some
      | _ => None
      }
    )

    None
  })

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
        {isNarrow
          ? React.null
          : <ErrorBoundary
              fallback={({error}) => error->JSON.stringifyAny->Option.getExn->React.string}>
              <React.Suspense fallback={<div />}>
                <Motion.Div
                  layoutId="bottom-nav"
                  layout={True}
                  className="w-full flex justify-center items-center z-50 py-4">
                  <BottomNav
                    voteContract={voteContract->Option.map(c => c.fragmentRefs)}
                    question={randomQuestion->Option.map(q => q.fragmentRefs)}
                    auction={newestVote
                    ->Option.flatMap(v => v.auction)
                    ->Option.map(a => a.fragmentRefs)}
                  />
                </Motion.Div>
              </React.Suspense>
            </ErrorBoundary>}
      </main>
      {isNarrow
        ? <ErrorBoundary
            fallback={({error}) => error->JSON.stringifyAny->Option.getExn->React.string}>
            <React.Suspense fallback={<div />}>
              <Motion.Div
                layoutId="bottom-nav"
                layout={True}
                className="fixed bottom-8 w-full flex justify-center items-center z-50 ">
                <BottomNav
                  voteContract={voteContract->Option.map(c => c.fragmentRefs)}
                  question={randomQuestion->Option.map(q => q.fragmentRefs)}
                  auction={newestVote
                  ->Option.flatMap(v => v.auction)
                  ->Option.map(a => a.fragmentRefs)}
                />
              </Motion.Div>
            </React.Suspense>
          </ErrorBoundary>
        : React.null}
      <div className="bg-default w-full relative">
        <VotesInfo />
      </div>
      <footer className="flex h-10  p-10 w-full bg-default" />
    </div>
  </>
}
