@module("/assets/RadarChart.png")
external radarChart: string = "default"
@send
external addEventListener: (Dom.window, [#resize], 'a => unit) => unit = "addEventListener"
@send
external removeEventListener: (Dom.window, [#resize], 'a => unit) => unit = "removeEventListener"

@get external innerWidth: Dom.window => int = "innerWidth"

@react.component
let make = (~children, ~isOpen) => {
  open FramerMotion
  let {address} = Wagmi.useAccount()
  let (width, setWidth) = React.useState(_ => window->innerWidth)
  let isNarrow = width <= 991
  let {setParams} = Routes.Main.Route.useQueryParams()

  let handleWindowSizeChange = () => {
    setWidth(_ => window->innerWidth)
  }

  React.useEffect0(() => {
    window->addEventListener(#resize, handleWindowSizeChange)

    Some(() => window->removeEventListener(#resize, handleWindowSizeChange))
  })

  let handleBackdropClick = e => {
    e->ReactEvent.Mouse.stopPropagation
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        voteDetails: None,
        voteDetailsToken: None,
      },
    )
  }

  let handleExitClick = _ =>
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        voteDetails: None,
        voteDetailsToken: None,
      },
    )

  let motionVariants: Motion.variants = {
    initial: Initial({
      width: isNarrow ? "100%" : "50%",
      x: isNarrow ? 100. : 0.,
    }),
    animate: Animate({
      width: isNarrow ? "100%" : "50%",
      x: 0.,
    }),
    exit: Exit({
      width: isNarrow ? "100%" : "0%",
      x: isNarrow ? 100. : 0.,
      transition: {
        duration: isNarrow ? 0.05 : 0.025,
      },
    }),
  }

  let content = switch address->Nullable.toOption {
  | None =>
    <div className="h-full w-full flex flex-col justify-around items-center">
      <div className="flex-1 text-center gap-3 flex-col flex justify-center items-center">
        <div> {"Connect an ethereum wallet to submit a vote"->React.string} </div>
        <RainbowKit.ConnectButton />
      </div>
      <div className="text-center flex-2">
        <div> {"Ask a community question"->React.string} </div>
        <a
          type_="button"
          className="bg-primary text-white rounded-lg px-4 py-2"
          href={"https://discord.gg/uwqMn3rxxj"}
          target="_blank">
          {"Discord"->React.string}
        </a>
      </div>
    </div>
  | Some(_) => children
  }

  <AnimatePresence initial=false>
    {switch isOpen {
    | false => React.null
    | true =>
      <>
        <AnimatePresence>
          <Motion.Div
            className="fixed top-0 right-0 w-full h-full bg-black opacity-50 z-40 "
            onClick={handleBackdropClick}
            initial={Initial({opacity: 0.})}
            animate={Animate({opacity: 0.5})}
          />
        </AnimatePresence>
        <Motion.Div
          variants=motionVariants
          initial=String("initial")
          animate=String("animate")
          exit=String("exit")
          className="w-full bg-background  transform-none h-screen fixed top-0 right-0 overflow-y-auto z-50 pb-[15vh] lg:w-1/2 ">
          <Motion.Div
            exit={Exit({
              opacity: !isNarrow ? 0. : 1.,
              transition: {
                duration: 0.01,
              },
            })}
            className="bg-background h-full   w-full py-4 px-[2%] overflow-y-scroll flex-flex-col justify-center items-center hide-scrollbar">
            <button className="fixed top-0 right-0 p-4" onClick={handleExitClick}>
              {"Exit"->React.string}
            </button>
            {content}
          </Motion.Div>
        </Motion.Div>
      </>
    }}
  </AnimatePresence>
}
