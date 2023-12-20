module Query = %relay(`
  query MainQuery($contextId: ID!) {
    ...Main_VoteConnectionFragment
    ...Main_QuestionConnectionFragment
    ...HeaderFragment
    userById(id: $contextId) {
      __typename
    }
  }
`)

module MainDisplay = {
  module VoteConnectionFragment = %relay(`
  fragment Main_VoteConnectionFragment on Query {
    voteConnection(orderBy: id, orderDirection: desc, first: 1000, after: "")
      @connection(key: "VotesConnection_voteConnection") {
      __id
      edges {
        node {
          tokenId
          auction {
            startTime
            tokenId
            ...BottomNav_auction
          }
          ...SingleVote_node
        }
      }
    }
  }`)

  module QuestionConnectionFragment = %relay(`
  fragment Main_QuestionConnectionFragment on Query {
    questionConnection(
      first: 1000
      orderBy: vote__tokenId
      orderDirection: asc
      where: { state_in: [Submitted, Approved] }
    ) @connection(key: "QuestionsConnection_questionConnection") {
      edges {
        node {
          ...SingleQuestion_node
          ...BottomNav_question
        }
      }
    }
  }`)
  @react.component
  let make = (~query as fragmentRefs, ~children) => {
    let {voteConnection} = VoteConnectionFragment.use(fragmentRefs)
    let newestVote = voteConnection->VoteConnectionFragment.getConnectionNodes->Array.get(0)

    let {questionConnection} = QuestionConnectionFragment.use(fragmentRefs)
    let newestQuestion =
      questionConnection->QuestionConnectionFragment.getConnectionNodes->Array.get(0)

    let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
    let isNarrow = width < 1024

    let handleWindowSizeChange = React.useCallback(() => {
      setWidth(_ => window->Window.innerWidth)
    })
    React.useEffect0(() => {
      window->Window.addEventListener(Resize, handleWindowSizeChange)

      Some(() => window->Window.removeEventListener(Resize, handleWindowSizeChange))
    })

    let {heroComponent} = React.useContext(HeroComponentContext.context)
    let {setAuction, setIsLoading: setIsAuctionLoading} = React.useContext(AuctionContext.context)
    let {setVote} = React.useContext(VoteContext.context)
    let {setQuestion} = React.useContext(QuestionContext.context)

    React.useEffect0(() => {
      switch newestVote {
      | Some(vote) => {
          setAuction(_ => vote.auction)
          setIsAuctionLoading(_ => false)
          setVote(_ => Some(vote))
          setQuestion(_ => newestQuestion)
        }
      | _ => ()
      }

      None
    })

    React.useEffect0(() => {
      let localAnswerTime =
        Dom.Storage2.localStorage
        ->Dom.Storage2.getItem("votesdev_answer_timestamp")
        ->Option.map(BigInt.fromString)

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
          <Header users=fragmentRefs />
        </React.Suspense>
      </ErrorBoundary>
      <div className="w-full pt-4">
        <div
          className="lg:flex-[0_0_auto] lg:max-w-6xl m-auto flex flex-col lg:flex-row  flex-shrink-0 max-w-full ">
          {heroComponent}
          <div
            className="pt-[5%] lg:pl-0 lg:pt-0 min-h-[558px] lg:flex-[0_0_auto] w-full bg-white pb-0 lg:bg-transparent lg:w-[50%]">
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
            ? <FramerMotion.Div
                layoutId="bottom-nav"
                layout={True}
                className="fixed bottom-8 w-full flex justify-center items-center z-50 ">
                <BottomNav
                  question={newestQuestion->Option.map(q => q.fragmentRefs)}
                  auction={newestVote
                  ->Option.flatMap(v => v.auction)
                  ->Option.map(a => a.fragmentRefs)}
                />
              </FramerMotion.Div>
            : <FramerMotion.Div
                layoutId="bottom-nav"
                layout={True}
                className="w-full flex justify-center items-center z-50 py-4">
                <BottomNav
                  question={newestQuestion->Option.map(q => q.fragmentRefs)}
                  auction={newestVote
                  ->Option.flatMap(v => v.auction)
                  ->Option.map(a => a.fragmentRefs)}
                />
              </FramerMotion.Div>}
        </React.Suspense>
      </ErrorBoundary>
    </>
  }
}

@react.component @relay.deferredComponent
let make = (~children, ~queryRef) => {
  let {fragmentRefs} = Query.usePreloaded(~queryRef)
  <div>
    <div className="relative w-full h-full flex flex-col z-0">
      <FramerMotion.Div
        layoutId="background-noise"
        className="fixed bg-primary noise animate-[grain_10s_steps(10)_infinite] flex flex-col z-[-1] w-[300%] h-[300%] left-[-50%] top-[-100%] overflow-hidden"
      />
      <main>
        <React.Suspense
          fallback={
            let title = "This is a placeholder for the daily question which will be rendered server side"

            <div
              className=" lg:max-w-6xl m-auto flex flex-col lg:flex-row  flex-shrink-0 max-w-full min-h-[558px] h-[558px] items-center justify-center ">
              <FramerMotion.Div
                layout=True
                layoutId="daily-question-title"
                className={`font-bold [text-wrap:balance] text-center text-default-darker px-4 text-2xl`}>
                {("\"" ++ title ++ "\"")->React.string}
              </FramerMotion.Div>
            </div>
          }>
          <MainDisplay query=fragmentRefs> {children} </MainDisplay>
        </React.Suspense>
      </main>
      <div className="bg-default w-full relative">
        <VotesInfo />
      </div>
      <footer className="flex h-10  p-10 w-full bg-default" />
    </div>
    <footer className="flex h-10  p-10 w-full bg-default" />
  </div>
}
