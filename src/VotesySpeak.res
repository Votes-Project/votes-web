@react.component
let make = () => {
  let {content, show, position, setPosition, setShow} = React.useContext(VotesySpeakContext.context)
  let ref = React.useRef(Nullable.null)
  let isOutside = OutsideClickHook.use(ref)
  let (inView, setInView) = React.useState(_ => false)

  React.useEffect3(() => {
    if isOutside && inView {
      setShow(_ => false)
      setInView(_ => false)
    }
    None
  }, (isOutside, setPosition, setInView))

  React.useEffect2(() => {
    switch ref.current->Nullable.toOption {
    | Some(current) if show =>
      Some(
        current->FramerMotion.inViewWithElement(~info=_ => {
          setInView(_ => true)
        }),
      )
    | _ => None
    }
  }, (ref, show))

  let parsePosition = (position: VotesySpeakContext.position) => {
    switch position {
    | Static => "static"
    | Absolute => "absolute"
    | Relative => "relative"
    | Fixed => "fixed"
    | Sticky => "sticky"
    }
  }

  <FramerMotion.AnimatePresence initial=false>
    {switch content {
    | Some(content) if show =>
      <FramerMotion.Div
        key="votesy-speak"
        layout=Position
        initial=Initial({height: "0px"})
        animate=Animate({height: "fit-content"})
        exit=Exit({height: "0px"})
        transition={{duration: 0.5, ease: EaseInOut}}
        className={`${parsePosition(
            position,
          )} top-24 bg-white rounded-lg px-4  font-semibold shadow-md whitespace-pre-wrap w-fit overflow-hidden z-40`}
        ref={ReactDOM.Ref.domRef(ref)}>
        {content}
      </FramerMotion.Div>
    | _ => React.null
    }}
  </FramerMotion.AnimatePresence>
}
