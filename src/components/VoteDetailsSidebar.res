@module("/assets/RadarChart.png")
external radarChart: string = "default"

@get external innerWidth: Dom.window => int = "innerWidth"

@react.component
let make = (~children, ~isOpen) => {
  open FramerMotion
  let (width, setWidth) = React.useState(_ => window->innerWidth)
  let isNarrow = width <= 991
  let {setParams} = Routes.Main.Route.useQueryParams()

  let setVoteDetails = voteDetails => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        voteDetails,
      },
    )
  }

  let handleBackdropClick = e => {
    e->ReactEvent.Mouse.stopPropagation
    setVoteDetails(None)
  }

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
          className="w-full bg-primary  transform-none h-screen fixed top-0 right-0 overflow-y-auto z-50 pb-[15vh] lg:w-1/2 ">
          <Motion.Div
            exit={Exit({
              opacity: !isNarrow ? 0. : 1.,
              transition: {
                duration: 0.01,
              },
            })}
            className="bg-primary  w-full py-4 px-[2%] h-fit overflow-y-scroll flex-flex-col justify-center items-center hide-scrollbar">
            <button className="fixed top-0 right-0 p-4" onClick={_ => setVoteDetails(None)}>
              {"Exit"->React.string}
            </button>
            <div className="h-auto max-w-md my-0 mx-auto w-full aspect-square">
              <img src=radarChart />
            </div>
            <div className="h-auto mx-4">
              <h2> {"Content"->React.string} </h2>
            </div>
          </Motion.Div>
        </Motion.Div>
      </>
    }}
  </AnimatePresence>
}
