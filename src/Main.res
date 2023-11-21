module Query = %relay(`
  query MainQuery($voteContractAddress: String!, $contextId: String!) {
    ...MainFragment
      @arguments(contextId: $contextId, voteContractAddress: $voteContractAddress)
    ...HeaderFragment
  }
`)

module MainDisplay = {
  module Fragment = %relay(`
  fragment MainFragment on Query
  @argumentDefinitions(
    contextId: { type: "String!" }
    voteContractAddress: { type: "String!" }
  ) {
    votes(orderBy: id, orderDirection: desc, first: 1000, after: "")
      @connection(key: "VotesConnection_votes") {
      __id
      edges {
        node {
          ...SingleVote_node
        }
      }
    }
    randomQuestion {
      id
      ...SingleQuestion_node
      ...BottomNav_question
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
    newestVote(voteContractAddress: $voteContractAddress) {
      id
      auction {
        startTime
        tokenId
        ...BottomNav_auction
      }
      ...SingleVote_node
    }
  }`)

  @react.component
  let make = (~fragmentRefs, ~children) => {
    open FramerMotion

    let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
    let isNarrow = width < 1024

    let handleWindowSizeChange = React.useCallback(() => {
      setWidth(_ => window->Window.innerWidth)
    })
    React.useEffect0(() => {
      window->Window.addEventListener(Resize, handleWindowSizeChange)

      Some(() => window->Window.removeEventListener(Resize, handleWindowSizeChange))
    })

    let {randomQuestion, verification, newestVote} = Fragment.use(fragmentRefs)

    let {heroComponent} = React.useContext(HeroComponentContext.context)
    let {setAuction, setIsLoading: setIsAuctionLoading} = React.useContext(AuctionContext.context)
    let {setVote} = React.useContext(VoteContext.context)
    let {setQuestion} = React.useContext(QuestionContext.context)
    let {setVerification} = React.useContext(VerificationContext.context)

    React.useEffect0(() => {
      switch newestVote {
      | Some(vote) => {
          setAuction(_ => vote.auction)
          setIsAuctionLoading(_ => false)
          setVote(_ => Some(vote))
          setQuestion(_ => randomQuestion->Option.map(q => q.fragmentRefs))
        }
      | _ => ()
      }

      setVerification(_ =>
        switch verification {
        | VerificationData({id, unique}) => VerificationContext.Verification({id, unique})->Some
        | Error({error}) => VerificationContext.Error({error: error})->Some
        | _ => None
        }
      )

      None
    })

    React.useEffect0(() => {
      let localAnswerTime =
        Dom.Storage2.localStorage
        ->Dom.Storage2.getItem("votesdev_answer_timestamp")
        ->Option.flatMap(Float.fromString)
        ->Option.map(Date.fromTime)

      switch (newestVote, localAnswerTime) {
      | (Some({auction: Some({startTime})}), Some(localAnswerTime))
        if localAnswerTime < startTime =>
        Dom.Storage2.localStorage->Dom.Storage2.removeItem("votesdev_answer_jwt")
      | (_, None) => Dom.Storage2.localStorage->Dom.Storage2.removeItem("votesdev_answer_jwt")
      | _ => ()
      }

      None
    })

    <>
      <ErrorBoundary fallback={_ => <div />}>
        <React.Suspense fallback={<div />}>
          <Header verifications=fragmentRefs />
        </React.Suspense>
      </ErrorBoundary>
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
      <ErrorBoundary fallback={({error}) => error->JSON.stringifyAny->Option.getExn->React.string}>
        <React.Suspense fallback={<div />}>
          {isNarrow
            ? <Motion.Div
                layoutId="bottom-nav"
                layout={True}
                className="fixed bottom-8 w-full flex justify-center items-center z-50 ">
                <BottomNav
                  question={randomQuestion->Option.map(q => q.fragmentRefs)}
                  auction={newestVote
                  ->Option.flatMap(v => v.auction)
                  ->Option.map(a => a.fragmentRefs)}
                />
              </Motion.Div>
            : <Motion.Div
                layoutId="bottom-nav"
                layout={True}
                className="w-full flex justify-center items-center z-50 py-4">
                <BottomNav
                  question={randomQuestion->Option.map(q => q.fragmentRefs)}
                  auction={newestVote
                  ->Option.flatMap(v => v.auction)
                  ->Option.map(a => a.fragmentRefs)}
                />
              </Motion.Div>}
        </React.Suspense>
      </ErrorBoundary>
    </>
  }
}

@react.component @relay.deferredComponent
let make = (~children, ~queryRef) => {
  let {fragmentRefs} = Query.usePreloaded(~queryRef)

  open FramerMotion
  <>
    <div className="relative w-full h-full flex flex-col z-0">
      <Motion.Div
        layoutId="background-noise"
        className="fixed bg-primary noise animate-[grain_10s_steps(10)_infinite] flex flex-col z-[-1] w-[300%] h-[300%] left-[-50%] top-[-100%] overflow-hidden"
      />
      <main>
        <React.Suspense
          fallback={
            let title = "This is a placeholder for the daily question which will be rendered server side"

            <div
              className=" lg:max-w-6xl m-auto flex flex-col lg:flex-row  flex-shrink-0 max-w-full min-h-[558px] h-[558px] items-center justify-center ">
              <Motion.Div
                layout=True
                layoutId="daily-question-title"
                className={`font-bold [text-wrap:balance] text-center text-default-darker px-4 text-2xl`}>
                {("\"" ++ title ++ "\"")->React.string}
              </Motion.Div>
            </div>
          }>
          <MainDisplay fragmentRefs> {children} </MainDisplay>
        </React.Suspense>
      </main>
      <div className="bg-default w-full relative">
        <VotesInfo />
      </div>
      <footer className="flex h-10  p-10 w-full bg-default" />
    </div>
  </>
}
