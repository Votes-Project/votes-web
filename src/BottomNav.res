module Fragment = %relay(`
  fragment BottomNav_voteContract on VoteContract {
    totalSupply
     }
`)

@react.component
let make = (~voteContract) => {
  let contract = voteContract->Fragment.useOpt

  let (scrollId, setScrollId) = React.useState(_ => None)
  let (isHidden, setIsHidden) = React.useState(_ => false)

  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let isNarrow = width <= 991

  let newestTokenId = {
    open BigInt
    contract
    ->Option.map(({totalSupply}) => totalSupply->fromString->sub(fromInt(1))->toString)
    ->Option.getExn
  }

  let handleScroll = _ => {
    let id = setTimeout(() => setScrollId(_ => None), 10)

    setScrollId(prevId => {
      prevId->Option.mapWithDefault((), prevId => window->Window.clearTimeout(prevId))
      setIsHidden(_ => true)
      Some(id)
    })
  }

  React.useEffect2(() => {
    switch scrollId {
    | None => setIsHidden(_ => false)
    | Some(_) => setIsHidden(_ => true)
    }
    None
  }, (scrollId, setIsHidden))

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
      opacity: isHidden ? 0. : 1.,
    }),
    animate: Animate({
      width: isNarrow ? "65%" : "24rem",
      opacity: isHidden ? 0.1 : 1.,
      transition: {duration: 0.1, ease: EaseInOut},
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
            {"Ask"->React.string}
          </RelayRouter.Link>
          <RelayRouter.Link
            to_={Routes.Main.Question.Current.Route.makeLink()}
            className="inline-flex items-center px-1 pt-1">
            {"Answer"->React.string}
          </RelayRouter.Link>
          <RelayRouter.Link
            to_={Routes.Main.Vote.Auction.Route.makeLink(~tokenId=newestTokenId)}
            className="inline-flex items-center px-1 pt-1">
            {"Auction"->React.string}
          </RelayRouter.Link>
        </div>
      </Motion.Nav>
    </div>
  </AnimatePresence>
}
