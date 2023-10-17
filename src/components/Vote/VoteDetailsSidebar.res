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
  let {address} = Wagmi.UseAccount.make()
  let (width, setWidth) = React.useState(_ => window->innerWidth)
  let isNarrow = width <= 991
  let {setParams, queryParams} = Routes.Main.Route.useQueryParams()

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
          className="w-full transform-none h-full fixed top-0 right-0 z-50 lg:w-1/2 ">
          <Motion.Div
            exit={Exit({
              opacity: !isNarrow ? 0. : 1.,
              transition: {
                duration: 0.01,
              },
            })}
            className="relative bg-transparent h-full w-full overflow-hidden flex flex-col justify-center items-center hide-scrollbar">
            <div
              className="absolute w-[300%] h-[300%] bg-default left-[-50%] top-[-100%] noise overflow-hidden animate-[grain_10s_steps(10)_infinite]"
            />
            {children}
          </Motion.Div>
        </Motion.Div>
      </>
    }}
  </AnimatePresence>
}
