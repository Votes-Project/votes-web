module MainDisplay = {
  module UserFragment = %relay(`
  fragment Main_user on Query @argumentDefinitions(id: { type: "ID!" }) {
    userById(id: $id) {
      answers(last: 1) {
        nodes {
          day
          ...NewestQuestion_answer
          ...BottomNav_answer
        }
      }
    }
  }
`)

  module VoteContractFragment = %relay(`
  fragment Main_voteContract on Query @argumentDefinitions(id: { type: "ID!" }) {
    voteContract(id: $id) {
      lastMintedVote {
        tokenId
        auction {
          startTime
          tokenId
          ...BottomNav_auction
        }
        ...SingleVote_node
      }
    }
  }`)

  module QuestionsContractFragment = %relay(`
fragment Main_questionsContract on Query
@argumentDefinitions(id: { type: "ID!" }) {
  questionsContract(id: $id) {
    lastUsedQuestion {
      day
      ...NewestQuestion_question
      ...BottomNav_question
    }
  }
}
`)

  @react.component
  let make = (~query as fragmentRefs, ~children) => {
    let {userById: user} = UserFragment.use(fragmentRefs)
    let newestAnswer =
      user->Option.flatMap(({answers}) => answers.nodes->Array.get(0))->Option.flatMap(a => a)

    let {voteContract} = VoteContractFragment.use(fragmentRefs)
    let newestVote = voteContract->Option.flatMap(({lastMintedVote}) => lastMintedVote)

    let {questionsContract} = QuestionsContractFragment.use(fragmentRefs)
    let newestQuestion = questionsContract->Option.flatMap(({lastUsedQuestion}) => lastUsedQuestion)

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
    let location = RelayRouter.Utils.useLocation()
    let isSubroute = location.pathname !== "/"

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
            {switch (newestAnswer, newestQuestion) {
            | _ if isSubroute =>
              <ErrorBoundary
                fallback={({error}) => {
                  error->JSON.stringifyAny->Option.getWithDefault("")->React.string
                }}>
                <React.Suspense fallback={<div />}> {children} </React.Suspense>
              </ErrorBoundary>
            | (Some({day}), Some({day: Some(questionDay)})) if day == BigInt.toInt(questionDay) =>
              <SingleVote.NewestVote vote={newestVote->Option.map(v => v.fragmentRefs)} />
            | (newestAnswer, Some({fragmentRefs})) =>
              <NewestQuestion
                question={fragmentRefs} answer={newestAnswer->Option.map(a => a.fragmentRefs)}
              />
            | _ => React.null
            }}
          </div>
        </div>
      </div>
      <ErrorBoundary
        fallback={({error}) => {
          Console.log(error)
          React.null
        }}>
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
                  answer={newestAnswer->Option.map(a => a.fragmentRefs)}
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
                  answer={newestAnswer->Option.map(a => a.fragmentRefs)}
                />
              </FramerMotion.Div>}
        </React.Suspense>
      </ErrorBoundary>
    </>
  }
}

module Query = %relay(`
  query MainQuery(
    $contextId: ID!
    $voteContractAddress: ID!
    $questionsContractAddress: ID!
  ) {
    ...Main_voteContract @arguments(id: $voteContractAddress)
    ...Main_questionsContract @arguments(id: $questionsContractAddress)
    ...HeaderFragment
    ...Main_user @arguments(id: $contextId)
  }
`)

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
