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
      layoutId="daily-question-preview"
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
  let isNarrow = width <= 1024
  let (isOpen, setIsOpen) = React.useState(_ => isNarrow ? false : true)

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

  let keys = UseKeyPairHook.useKeyPair()

  let {setParams} = Routes.Main.Route.useQueryParams()
  let setDailyQuestion = dailyQuestion => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        contextId: keys->Option.map(({contextId}) => contextId),
        dailyQuestion,
      },
    )
  }

  let className = isOpen
    ? "flex items-center justify-center text-white bg-secondary w-full focus:ring-4 focus:ring-active focus:outline-none min-h-[6rem] shadow-lg px-4 py-4"
    : "flex items-center justify-center text-white bg-primary-dark  w-16 h-16 md:w-20 md:h-20 hover:bg-active  focus:ring-4 focus:ring-active focus:outline-none shadow-lg "

  let handleClick = _ => {
    if isOpen {
      setIsOpen(_ => false)
      setDailyQuestion(Some(0))
    } else {
      setIsOpen(_ => true)
    }
  }
  open FramerMotion

  <div
    id="daily-question-preview"
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
      {isOpen
        ? <QuestionTitle />
        : <Motion.Div layout=True className="text-4xl font-bold"> {"?"->React.string} </Motion.Div>}
    </Motion.Div>
  </div>
}
