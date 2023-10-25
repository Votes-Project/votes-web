let tap = x => {
  Console.log(x)
  x
}

// Fixed Bottom navigation bar that hides on scrolldown and appears on scroll up styled with tailwind. Bar contains 3 Items [New, Vote, Auction]
@react.component
let make = () => {
  let (scrollY, setScrollY) = React.useState(_ => window->Window.scrollY)
  let (isHidden, setIsHidden) = React.useState(_ => false)
  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let isNarrow = width <= 991

  let handleIsHidden = (prev, curr) =>
    switch curr {
    | curr if curr <= 0 => setIsHidden(_ => false)
    | curr if prev < curr => setIsHidden(_ => true)
    | _ => setIsHidden(_ => false)
    }

  let handleScroll = React.useCallback(e => {
    let y = (e->ReactEvent.UI.currentTarget)["scrollY"]

    setScrollY(prevY => {
      handleIsHidden(prevY, y)
      y
    })
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
      height: isNarrow ? "3rem" : "4rem",
      width: isNarrow ? "90%" : "36rem",
      // opacity: isHidden ? 0. : 1.,
    }),
    animate: Animate({
      height: isNarrow ? "3rem" : "4rem",
      width: isNarrow ? "90%" : "36rem",
      // opacity: isHidden ? 0. : 1.,
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
