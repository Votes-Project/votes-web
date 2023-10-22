@send
external addEventListener: (Dom.document, [#mouseup], 'a => unit) => unit = "addEventListener"
@send
external removeEventListener: (Dom.document, [#mouseup], 'a => unit) => unit = "removeEventListener"
let longTitle = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu?"

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
  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let (isOpen, setIsOpen) = React.useState(_ => false)

  let {auction} = React.useContext(AuctionContext.context)
  let {push} = RelayRouter.Utils.useRouter()
  let location = RelayRouter.Utils.useLocation()

  let isCurrentQuestionRouteActive = Routes.Main.Question.Current.Route.isRouteActive(
    location,
    ~exact=true,
  )

  let isNarrow = width <= 1024

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
    ? "flex items-center justify-center text-white bg-primary noise hover:bg-primary w-full focus:ring-4 focus:ring-active focus:outline-none min-h-[6rem] shadow-lg p-4"
    : "flex items-center justify-center text-white bg-primary-dark px-8 py-4 hover:bg-active focus:ring-4 focus:ring-active focus:outline-none shadow-lg w-32 "

  let handleClick = _ => {
    switch isCurrentQuestionRouteActive {
    | true =>
      let tokenId = auction->Option.map(auction => auction.tokenId)->Option.getExn
      Routes.Main.Vote.Auction.Route.makeLink(~tokenId)->push
      setIsOpen(_ => false)
    | false =>
      setIsOpen(_ => false)
      Routes.Main.Question.Current.Route.makeLink()->push
    }
  }
  open FramerMotion

  <div
    id="daily-question-title"
    className={`fixed ${isOpen
        ? "bottom-0 hover:scale-105 transition-transform duration-200 ease-in-out"
        : "right-6 bottom-6"} z-10 cursor-pointer `}
    onClick={handleClick}>
    {isOpen
      ? <div className="absolute w-screen h-screen z-10" onClick={_ => setIsOpen(_ => false)} />
      : <> </>}
    <Motion.Div
      layout=True
      initial=Initial({borderRadius: 20})
      animate={isOpen ? Animate({borderRadius: 0}) : Animate({})}
      className>
      {switch (isOpen, isCurrentQuestionRouteActive) {
      | (true, _) =>
        <div className="flex flex-row items-center justify-between">
          <ReactIcons.LuVote />
          <QuestionTitle />
        </div>
      | (false, false) => <div className="text-2xl font-bold"> {"Vote"->React.string} </div>
      | (false, true) => <div className="text-2xl font-bold"> {"Auction"->React.string} </div>
      }}
    </Motion.Div>
  </div>
}
