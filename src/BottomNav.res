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

@react.component
let make = (~voteContract, ~question) => {
  let {
    queryParams: currentQuestionQueryParams,
  } = Routes.Main.Question.Current.Route.useQueryParams()
  let contract = voteContract->VoteContractFragment.useOpt
  let question = question->QuestionFragment.useOpt
  let (_, setScrollY) = React.useState(_ => window->Window.scrollY)

  let (disabled, setDisabled) = React.useState(_ => false)

  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let isNarrow = width <= 991

  let newestTokenId = {
    open BigInt
    contract
    ->Option.map(({totalSupply}) => totalSupply->fromString->sub(fromInt(1))->toString)
    ->Option.getExn
  }

  let handleScroll = React.useCallback2(_ => {
    let curr = window->Window.scrollY
    setScrollY(prev => {
      let _ = switch prev {
      | prev if prev > 1. && prev <= curr => setDisabled(_ => true)
      | _ => setDisabled(_ => false)
      }
      curr
    })
  }, (setDisabled, setScrollY))

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
    <div className="fixed bottom-8 w-full flex justify-center items-center z-50 ">
      <Motion.Nav
        className="w-full h-full text-default bg-default-darker shadow-xl backdrop-blur-md rounded-full max-w-sm"
        variants=motionVariants
        initial=String("initial")
        animate=String("animate")>
        <div className="flex py-2 justify-evenly items-center h-full text:md lg:text-lg font-bold">
          <RelayRouter.Link
            to_={Routes.Main.Vote.New.Route.makeLink()}
            className="inline-flex items-center px-1 pt-1 ">
            <button type_="button" disabled> {"Ask"->React.string} </button>
          </RelayRouter.Link>
          <RelayRouter.Link
            to_={Routes.Main.Question.Current.Route.makeLinkFromQueryParams({
              ...currentQuestionQueryParams,
              id: question->Option.map(({id}) => id),
            })}
            className="inline-flex items-center px-1 pt-1">
            <button type_="button" disabled> {"Answer"->React.string} </button>
          </RelayRouter.Link>
          <RelayRouter.Link
            to_={Routes.Main.Vote.Auction.Route.makeLink(~tokenId=newestTokenId)}
            className="inline-flex items-center px-1 pt-1">
            <button type_="button" disabled> {"Auction"->React.string} </button>
          </RelayRouter.Link>
        </div>
      </Motion.Nav>
    </div>
  </AnimatePresence>
}
