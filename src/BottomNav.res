module VoteContractFragment = %relay(`
  fragment BottomNav_voteContract on VoteContract {
    totalSupply
  }
`)
module QuestionFragment = %relay(`
  fragment BottomNav_question on Question {
    id
  }
`)

module AuctionFragment = %relay(`
  fragment BottomNav_auction on Auction {
    startTime
  }
`)

@react.component
let make = (~voteContract, ~question, ~auction) => {
  let (disabled, setDisabled) = React.useState(_ => false)
  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let isNarrow = width < 1024

  let contract = voteContract->VoteContractFragment.useOpt
  let question = question->QuestionFragment.useOpt
  let auction = auction->AuctionFragment.useOpt

  let newestTokenId = {
    open BigInt
    contract->Option.map(({totalSupply}) => totalSupply->sub(1->fromInt))->Option.getExn
  }

  let location = RelayRouter.Utils.useLocation()
  let {
    queryParams: currentQuestionQueryParams,
  } = Routes.Main.Question.Current.Route.useQueryParams()

  let voteActiveSubroutes = Routes.Main.Vote.Route.getActiveSubRoute(location)
  let mainActiveSubroutes = Routes.Main.Route.getActiveSubRoute(location)

  let hasAnsweredQuestion = {
    open Dom.Storage2
    let timestamp = localStorage->getItem("votes_answer_timestamp")->Option.map(BigInt.fromString)

    auction
    ->Option.map(auction => auction.startTime)
    ->Option.map(Date.getTime)
    ->Option.map(BigInt.fromFloat)
    ->Option.equal(timestamp, (startTime, lastVoteTimestamp) => startTime < lastVoteTimestamp)
  }

  let activeRoute = switch (mainActiveSubroutes, voteActiveSubroutes) {
  | (Some(#Question), _) => Some(#Question)
  | (_, Some(#Auction)) => Some(#Auction)
  | (_, Some(#New)) => Some(#New)
  | (None, None) if hasAnsweredQuestion == true => Some(#Auction)
  | (None, None) if hasAnsweredQuestion == false => Some(#Question)
  | _ => None
  }

  let handleScroll = React.useCallback0(_ => {
    setDisabled(_ => false)
  })

  let handleWindowSizeChange = React.useCallback(() => {
    setWidth(_ => window->Window.innerWidth)
  })

  React.useEffect0(() => {
    window->Window.addEventListener(Scroll, handleScroll)

    Some(() => window->Window.removeEventListener(Scroll, handleScroll))
  })

  React.useEffect0(() => {
    window->Window.addEventListener(Resize, handleWindowSizeChange)

    Some(() => window->Window.removeEventListener(Resize, handleWindowSizeChange))
  })

  open FramerMotion
  let motionVariants: Motion.variants = {
    initial: Initial({
      width: isNarrow ? "65%" : "24rem",
      opacity: disabled ? 0. : 1.,
    }),
    animate: Animate({
      width: isNarrow ? "65%" : "24rem",
      opacity: disabled ? 0.1 : 1.,
      transition: {duration: 0.2, ease: EaseInOut},
    }),
  }

  <AnimatePresence>
    <Motion.Nav
      className="w-full h-full text-default lg:text-default-light bg-default-darker lg:bg-primary-dark shadow-xl lg:shadow-none backdrop-blur-md rounded-full max-w-sm"
      variants=motionVariants
      initial=String("initial")
      animate=String("animate")
      onClick={() => setDisabled(_ => false)}>
      <ul
        className="w-full flex py-2 justify-evenly items-center h-full text:md lg:text-lg font-bold">
        <RelayRouter.Link
          to_={Routes.Main.Vote.New.Route.makeLink()}
          className="relative flex flex-1 items-center justify-center">
          <li className=" flex flex-1 items-center justify-center text-center">
            <button className="z-10" type_="button"> {"Ask"->React.string} </button>
            {activeRoute == Some(#New)
              ? <div className="absolute w-full">
                  <Motion.Div
                    className="w-1/2 md:w-1/4 absolute top-[-32px] left-0 right-0 mx-auto h-4 bg-default-darker lg:bg-primary-dark  rounded-t-full flex items-end justify-center pt-5"
                    layoutId="underline">
                    <div className="bg-default-light w-3 h-3 rounded-full " />
                  </Motion.Div>
                </div>
              : React.null}
          </li>
        </RelayRouter.Link>
        <RelayRouter.Link
          to_={Routes.Main.Question.Current.Route.makeLinkFromQueryParams({
            ...currentQuestionQueryParams,
            id: question->Option.map(({id}) => id),
          })}
          className="relative flex flex-1 items-center justify-center">
          <li className=" flex-1 items-center flex justify-center text-center">
            <button className="z-10" type_="button"> {"Answer"->React.string} </button>
            {activeRoute == Some(#Question)
              ? <div className="absolute w-full">
                  <Motion.Div
                    className="w-1/2 md:w-1/4 absolute top-[-32px] left-0 right-0 mx-auto h-4 bg-default-darker lg:bg-primary-dark rounded-t-full flex items-end justify-center pt-5"
                    layoutId="underline">
                    <div className="bg-default-light w-3 h-3 rounded-full" />
                  </Motion.Div>
                </div>
              : React.null}
          </li>
        </RelayRouter.Link>
        <RelayRouter.Link
          to_={Routes.Main.Vote.Auction.Route.makeLink(~tokenId=newestTokenId->BigInt.toString)}
          preloadData={NoPreloading}
          className="relative flex flex-1 items-center justify-center">
          <li className=" flex-1 items-center flex justify-center text-center">
            <button className="z-10" type_="button"> {"Auction"->React.string} </button>
            {activeRoute == Some(#Auction)
              ? <div className="absolute w-full">
                  <Motion.Div
                    className="w-1/2 md:w-1/4 absolute top-[-32px] left-0 right-0 mx-auto h-4 bg-default-darker lg:bg-primary-dark  rounded-t-full flex items-end justify-center pt-5"
                    layoutId="underline">
                    <div className="bg-default-light w-3 h-3 rounded-full" />
                  </Motion.Div>
                </div>
              : React.null}
          </li>
        </RelayRouter.Link>
      </ul>
    </Motion.Nav>
  </AnimatePresence>
}
