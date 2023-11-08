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

module Fragment = %relay(`
  fragment QuestionPreview_voteContract on VoteContract {
    totalSupply
  }
`)

@react.component
let make = (~voteContract) => {
  let {auction} = React.useContext(AuctionContext.context)

  let (width, setWidth) = React.useState(_ => window->Window.innerWidth)
  let (isOpen, setIsOpen) = React.useState(_ => false)

  let hasAnswered = {
    open BigInt
    open Dom.Storage2
    let timestamp = localStorage->getItem("votes_answer_timestamp")->Option.getWithDefault("0")

    let auctionStartTime =
      auction->Option.mapWithDefault(Date.fromString("0"), auction => auction.startTime)
    auctionStartTime->Date.toTimeString->BigInt.fromString < timestamp->fromString
  }

  let location = RelayRouter.Utils.useLocation()

  let isCurrentQuestionRouteActive = Routes.Main.Question.Current.Route.isRouteActive(
    location,
    ~exact=true,
  )

  let isMainRouteActive = Routes.Main.Route.isRouteActive(location, ~exact=true)

  let isShowingQuestion = isCurrentQuestionRouteActive || (!hasAnswered && isMainRouteActive)

  let isOpenHandler = (isShowingQuestion, width) => {
    switch (isShowingQuestion, width > 1024) {
    | (true, _) => false
    | (false, true) => true
    | _ => false
    }
  }

  let {totalSupply} = Fragment.use(voteContract->Option.getExn)

  let newestTokenId = {
    open BigInt
    totalSupply->sub(1->fromInt)->toString
  }

  let handleWindowSizeChange = React.useCallback(() => {
    setWidth(_ => window->Window.innerWidth)
    setIsOpen(_ => isOpenHandler(isShowingQuestion, window->Window.innerWidth))
  })

  React.useEffect0(() => {
    window->Window.addEventListener(Resize, handleWindowSizeChange)

    Some(() => window->Window.removeEventListener(Resize, handleWindowSizeChange))
  })

  React.useEffect2(() => {
    setIsOpen(_ => isOpenHandler(isShowingQuestion, width))
    None
  }, (isShowingQuestion, width))

  let className = isOpen
    ? "flex items-center justify-center text-white bg-primary noise  w-full focus:ring-4 focus:ring-active focus:outline-none min-h-[6rem] shadow-lg p-4"
    : "flex items-center justify-center text-white bg-primary-dark px-8 py-4 hover:scale-105 focus:ring-4 focus:ring-active focus:outline-none shadow-lg w-32 "

  let linkLocation = switch isShowingQuestion {
  | false => Routes.Main.Question.Current.Route.makeLink()
  | true => Routes.Main.Vote.Auction.Route.makeLink(~tokenId=newestTokenId)
  }

  open FramerMotion
  <RelayRouter.Link
    to_=linkLocation
    id="daily-question-title"
    className={`cursor-pointer fixed ${isOpen
        ? "bottom-0 hover:scale-105 transition-transform duration-200 ease-in-out"
        : "right-6 bottom-6"} z-10 `}>
    <Motion.Div
      layout=True
      initial=Initial({borderRadius: Pixel(20)})
      animate={isOpen ? Animate({borderRadius: Pixel(0)}) : Animate({})}
      className>
      {switch (isOpen, isShowingQuestion) {
      | (true, _) =>
        <div className="flex flex-row items-center justify-between">
          <QuestionTitle />
          <ReactIcons.LuVote />
        </div>
      | (false, false) =>
        <Motion.Div layout=True className="text-2xl font-bold"> {"Vote"->React.string} </Motion.Div>
      | (false, true) =>
        <Motion.Div layout=True className="text-2xl font-bold">
          {"Auction"->React.string}
        </Motion.Div>
      }}
    </Motion.Div>
  </RelayRouter.Link>
}
