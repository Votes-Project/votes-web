@react.component
let make = () => {
  let (scrollId, setScrollId) = React.useState(_ => None)
  let (_, setScrollY) = React.useState(_ => window->Window.scrollY)

  let (isHidden, setIsHidden) = React.useState(_ => false)

  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let isNarrow = width <= 991

  let handleScroll = e => {
    let y = (e->ReactEvent.UI.currentTarget)["scrollY"]

    let id = setTimeout(() => setScrollId(_ => None), 10)

    setScrollId(prevId => {
      prevId->Option.mapWithDefault((), prevId => window->Window.clearTimeout(prevId))
      setScrollY(prevY =>
        switch prevY {
        | prevY if prevY < y =>
          setIsHidden(_ => true)
          y
        | _ =>
          setIsHidden(_ => false)
          y
        }
      )
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
      height: isNarrow ? "3rem" : "4rem",
      width: isNarrow ? "90%" : "36rem",
      opacity: isHidden ? 0. : 1.,
    }),
    animate: Animate({
      height: isNarrow ? "3rem" : "4rem",
      width: isNarrow ? "90%" : "36rem",
      opacity: isHidden ? 0.1 : 1.,
    }),
  }

  <AnimatePresence>
    <div className="fixed bottom-8 w-full flex justify-center items-center z-50 ">
      <Motion.Nav
        className="w-full h-full bg-default-light/80 shadow-xl backdrop-blur-md rounded-full "
        variants=motionVariants
        initial=String("initial")
        animate=String("animate")>
        <div className="flex justify-evenly items-center h-full text:md lg:text-lg font-semibold">
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
            to_={Routes.Main.Vote.Auction.Route.makeLink(~tokenId="0")}
            className="inline-flex items-center px-1 pt-1">
            {"Auction"->React.string}
          </RelayRouter.Link>
        </div>
      </Motion.Nav>
    </div>
  </AnimatePresence>
}
