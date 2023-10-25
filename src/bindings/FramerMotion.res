module Motion = {
  type layout = | @as("position") Position | @as(true) True | String(string)
  @unboxed
  type ease =
    | @as("easeIn") EaseIn
    | @as("easeOut") EaseOut
    | @as("easeInOut") EaseInOut
    | @as("circIn") CircIn
    | @as("circOut") CircOut
    | @as("circInOut") CircInOut
    | @as("backIn") BackIn
    | @as("backOut") BackOut
    | @as("backInOut") BackInOut
    | @as("anticipate") Anticipate
    | @as("linear") Linear
    | Ease(array<string>)
  type transition = {duration?: float, ease?: ease}

  type motionValues = {
    x?: float,
    y?: float,
    scale?: float,
    rotate?: float,
    opacity?: float,
    backgroundColor?: string,
    width?: string,
    height?: string,
    transition?: transition,
    borderRadius?: int,
  }

  @unboxed type initial = Initial(motionValues) | String(string)
  @unboxed type animate = Animate(motionValues) | String(string)
  @unboxed type exit = Exit(motionValues) | String(string)

  type variants = {
    initial?: initial,
    animate?: animate,
    transition?: transition,
    exit?: exit,
  }
  module Div = {
    @react.component @module("framer-motion") @scope("motion")
    external make: (
      ~layoutId: string=?,
      ~layout: layout=?,
      ~variants: variants=?,
      ~initial: initial=?,
      ~animate: animate=?,
      ~exit: exit=?,
      ~transition: transition=?,
      ~children: React.element=?,
      ~className: string=?,
      ~onClick: 'a => unit=?,
      ~onMouseEnter: 'a => unit=?,
      ~onMouseLeave: 'a => unit=?,
      ~ref: ReactDOM.domRef=?,
    ) => React.element = "div"
  }

  module Button = {
    @react.component @module("framer-motion") @scope("motion")
    external make: (
      ~layoutId: string=?,
      ~layout: string=?,
      ~variants: variants=?,
      ~initial: initial=?,
      ~animate: animate=?,
      ~exit: exit=?,
      ~transition: transition=?,
      ~children: React.element=?,
      ~className: string=?,
      ~onClick: 'a => unit=?,
      ~onMouseEnter: 'a => unit=?,
      ~onMouseLeave: 'a => unit=?,
      ~type_: string=?,
    ) => React.element = "div"
  }

  module Li = {
    @react.component @module("framer-motion") @scope("motion")
    external make: (
      ~layoutId: string=?,
      ~layout: layout=?,
      ~variants: variants=?,
      ~initial: initial=?,
      ~animate: animate=?,
      ~exit: exit=?,
      ~transition: transition=?,
      ~children: React.element=?,
      ~className: string=?,
      ~onClick: 'a => unit=?,
      ~onMouseEnter: 'a => unit=?,
      ~onMouseLeave: 'a => unit=?,
      ~ref: ReactDOM.domRef=?,
      ~key: string=?,
    ) => React.element = "div"
  }
}

module AnimatePresence = {
  type mode = | @as("sync") Sync | @as("wait") Wait | @as("popLayout") PopLayout

  @react.component @module("framer-motion")
  external make: (
    ~onExitComplete: unit => unit=?,
    ~initial: bool=?,
    ~mode: mode=?,
    ~children: React.element=?,
    ~className: string=?,
  ) => React.element = "AnimatePresence"
}
