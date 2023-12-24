module QuestionFragment = %relay(`
  fragment BottomNav_question on Question {
    id
    day
  }
`)

module AuctionFragment = %relay(`
  fragment BottomNav_auction on Auction {
    startTime
    tokenId
  }
`)

module AnswerFragment = %relay(`
  fragment BottomNav_answer on Answer {
    __typename
  }
`)

@react.component
let make = (~question, ~auction, ~answer) => {
  let (disabled, setDisabled) = React.useState(_ => false)
  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let isNarrow = width < 1024

  let question = question->QuestionFragment.useOpt
  let auction = auction->AuctionFragment.useOpt
  let answer = answer->AnswerFragment.useOpt

  let newestTokenId = auction->Option.mapWithDefault("", a => a.tokenId->BigInt.toString)

  let location = RelayRouter.Utils.useLocation()

  let activeRoute = switch location.pathname {
  | pathname if pathname === "/" =>
    switch answer {
    | Some(_) => #Auction
    | None => #Question
    }
  | pathname if pathname->String.includes("/ask") => #Ask
  | pathname if pathname->String.includes("/question") => #Question
  | pathname if pathname->String.includes("/vote") => #Auction
  | _ => #Question
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
  let motionVariants: variants = {
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
    <FramerMotion.Nav
      className="w-full h-full text-default lg:text-default-light bg-default-darker lg:bg-primary-dark shadow-xl lg:shadow-none backdrop-blur-md rounded-full max-w-sm "
      variants=motionVariants
      initial=String("initial")
      animate=String("animate")
      onClick={_ => setDisabled(_ => false)}>
      <ul
        className="w-full flex py-2 justify-evenly items-center h-full text:md lg:text-lg font-bold">
        <RelayRouter.Link
          to_={Routes.Main.Question.Ask.Route.makeLink()}
          className="relative flex flex-1 items-center justify-center">
          <li className=" flex flex-1 items-center justify-center text-center">
            <button className="z-10" type_="button"> {"Ask"->React.string} </button>
            {activeRoute == #Ask
              ? <div className="absolute w-full">
                  <FramerMotion.Div
                    className="w-1/2 md:w-1/4 absolute top-[-32px] left-0 right-0 mx-auto h-4 bg-default-darker lg:bg-primary-dark  rounded-t-full flex items-end justify-center pt-5"
                    layoutId="underline">
                    <div className="bg-default-light w-3 h-3 rounded-full " />
                  </FramerMotion.Div>
                </div>
              : React.null}
          </li>
        </RelayRouter.Link>
        <RelayRouter.Link
          to_={Routes.Main.Question.Details.Route.makeLink(
            ~question=question->Option.map(({id}) => id)->Option.getWithDefault(""),
          )}
          className="relative flex flex-1 items-center justify-center">
          <li className=" flex-1 items-center flex justify-center text-center">
            <button className="z-10" type_="button"> {"Answer"->React.string} </button>
            {activeRoute == #Question
              ? <div className="absolute w-full">
                  <FramerMotion.Div
                    className="w-1/2 md:w-1/4 absolute top-[-32px] left-0 right-0 mx-auto h-4 bg-default-darker lg:bg-primary-dark rounded-t-full flex items-end justify-center pt-5"
                    layoutId="underline">
                    <div className="bg-default-light w-3 h-3 rounded-full" />
                  </FramerMotion.Div>
                </div>
              : React.null}
          </li>
        </RelayRouter.Link>
        <RelayRouter.Link
          to_={Routes.Main.Vote.Auction.Route.makeLink(~tokenId=newestTokenId)}
          preloadData={NoPreloading}
          className="relative flex flex-1 items-center justify-center">
          <li className=" flex-1 items-center flex justify-center text-center">
            <button className="z-10" type_="button"> {"Auction"->React.string} </button>
            {activeRoute == #Auction
              ? <div className="absolute w-full">
                  <FramerMotion.Div
                    className="w-1/2 md:w-1/4 absolute top-[-32px] left-0 right-0 mx-auto h-4 bg-default-darker lg:bg-primary-dark  rounded-t-full flex items-end justify-center pt-5"
                    layoutId="underline">
                    <div className="bg-default-light w-3 h-3 rounded-full" />
                  </FramerMotion.Div>
                </div>
              : React.null}
          </li>
        </RelayRouter.Link>
      </ul>
    </FramerMotion.Nav>
  </AnimatePresence>
}
