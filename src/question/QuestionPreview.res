@send
external addEventListener: (Dom.document, [#mouseup], 'a => unit) => unit = "addEventListener"
@send
external removeEventListener: (Dom.document, [#mouseup], 'a => unit) => unit = "removeEventListener"
let longTitle = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu?"

module Window = {
  @send
  external addEventListener: (Dom.window, [#resize], 'a => unit) => unit = "addEventListener"
  @send
  external removeEventListener: (Dom.window, [#resize], 'a => unit) => unit = "removeEventListener"
  @get external innerWidth: Dom.window => int = "innerWidth"
}

module QuestionTitle = {
  let titleStyle = titleLength => {
    if titleLength <= 50 {
      "text-4xl"
    } else if titleLength <= 100 {
      "text-2xl"
    } else if titleLength <= 150 {
      "text-xl"
    } else if titleLength <= 200 {
      "text-lg"
    } else {
      "text-md"
    }
  }

  let title = longTitle
  @react.component
  let make = () => {
    open FramerMotion
    <Motion.Div
      layout=True
      layoutId="daily-question-title"
      className={`font-bold [text-wrap:balance] text-center text-default-darker px-4  ${titleStyle(
          title->String.length,
        )}`}>
      {("\"" ++ title ++ "\"")->React.string}
    </Motion.Div>
  }
}

@react.component
let make = () => {
  let {push} = RelayRouter.Utils.useRouter()
  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let isNarrow = width <= 1024
  let location = RelayRouter.Utils.useLocation()
  let {auction} = React.useContext(AuctionContext.context)
  let isCurrentQuestionRouteActive = Routes.Main.Question.Current.Route.isRouteActive(
    location,
    ~exact=true,
  )

  let (isOpen, setIsOpen) = React.useState(_ => !isNarrow || !isCurrentQuestionRouteActive)

  let handleWindowSizeChange = React.useCallback(() => {
    setWidth(_ => window->Window.innerWidth)
    if window->Window.innerWidth <= 1024 {
      setIsOpen(_ => false)
    } else {
      setIsOpen(_ => true)
    }
  })

  React.useEffect0(() => {
    window->Window.addEventListener(#resize, handleWindowSizeChange)

    Some(() => window->Window.removeEventListener(#resize, handleWindowSizeChange))
  })

  React.useEffect1(() => {
    if isCurrentQuestionRouteActive {
      setIsOpen(_ => false)
    } else {
      setIsOpen(_ => !isNarrow)
    }
    None
  }, [isCurrentQuestionRouteActive])

  let className = isOpen
    ? "flex items-center justify-center text-white bg-secondary w-full focus:ring-4 focus:ring-active focus:outline-none min-h-[6rem] shadow-lg px-4 py-4"
    : "flex items-center justify-center text-white bg-primary-dark  w-16 h-16 md:w-20 md:h-20 hover:bg-active  focus:ring-4 focus:ring-active focus:outline-none shadow-lg "

  let handleClick = _ => {
    switch (isOpen, isCurrentQuestionRouteActive) {
    | (_, true) =>
      let tokenId = auction->Option.map(auction => auction.tokenId)->Option.getExn
      Routes.Main.Vote.Auction.Route.makeLink(~tokenId)->push
      setIsOpen(_ => false)
    | (true, _) =>
      setIsOpen(_ => false)
      Routes.Main.Question.Current.Route.makeLink()->push
    | (false, _) => setIsOpen(_ => true)
    }
  }
  open FramerMotion

  <div
    id="daily-question-title"
    className={`fixed ${isOpen ? "bottom-0" : "right-6 bottom-6"} z-10 cursor-pointer`}
    onClick={handleClick}>
    {isOpen
      ? <div className="absolute w-screen h-screen z-10" onClick={_ => setIsOpen(_ => false)} />
      : <> </>}
    <Motion.Div
      layout=True
      initial=Initial({borderRadius: 50})
      animate={isOpen ? Animate({borderRadius: 0}) : Animate({})}
      className>
      {switch (isOpen, isCurrentQuestionRouteActive) {
      | (true, _) => <QuestionTitle />
      | (false, false) =>
        <Motion.Div layout=True className="text-4xl font-bold">
          <ReactIcons.LuVote />
        </Motion.Div>
      | (false, true) =>
        <Motion.Div layout=True className="text-4xl font-bold">
          <ReactIcons.LuCheckCircle />
        </Motion.Div>
      }}
    </Motion.Div>
  </div>
}
