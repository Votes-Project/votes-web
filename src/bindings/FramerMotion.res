type line = {x: float, y: float}
type boundingBox2D = {top?: int, left?: int, right?: int, bottom?: int}

module Drag = {
  type t = Boolean | @as("x") X | @as("y") Y

  type info = {point: line, delta: line, offset: line, velocity: line}

  @unboxed type dragConstraints = False | Ref(React.ref<Nullable.t<Dom.element>>)
}
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
  @unboxed type borderRadius = Pixel(int) | Percentage(string)

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
    borderRadius?: borderRadius,
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
      ~drag: Drag.t=?,
      ~whileDrag: variants=?,
      ~dragSnapToOrigin: bool=?,
      ~dragConstraints: Drag.dragConstraints=?,
      ~dragMomentum: bool=?,
      ~onDrag: ('a, Drag.info) => unit=?,
      ~onDragStart: ('a, Drag.info) => unit=?,
      ~onDragEnd: ('a, Drag.info) => unit=?,
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
    ) => React.element = "button"
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
    ) => React.element = "li"
  }
  module Nav = {
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
    ) => React.element = "nav"
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
