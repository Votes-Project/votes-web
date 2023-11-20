type point2D = {x: float, y: float}
type boundingBox2D = {top?: int, left?: int, right?: int, bottom?: int}
type boundingBox2DFloat = {top?: float, left?: float, right?: float, bottom?: float}

module Drag = {
  type t = Boolean | @as("x") X | @as("y") Y

  type info = {point: point2D, delta: point2D, offset: point2D, velocity: point2D}
  @unboxed type dragElastic = Boolean | Float(float) | Box(boundingBox2DFloat)
  type inertiaOptions = {
    timeConstant?: int,
    power?: float,
    bounceStiffness?: float,
    bounceDamping?: float,
    min?: int,
  }

  @unboxed type dragConstraints = False | Ref(React.ref<Nullable.t<Dom.element>>)
  module Controls = {
    type options = {snapToCursor?: bool, snapToOrigin?: bool, threshold?: int}
    type t<'event> = {start: ('event, ~options: options=?) => unit, stop: unit => unit}
    @module("framer-motion") external use: unit => t<'event> = "useDragControls"
  }
}

module Pan = {
  type info = {point: point2D, delta: point2D, offset: point2D, velocity: point2D}
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
  type transition = {duration?: float, ease?: ease, delay?: float}
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
    borderTop?: string,
    borderBottom?: string,
    borderLeft?: string,
    borderRight?: string,
    border?: string,
    strokeDashoffset?: int,
  }

  @unboxed type initial = Initial(motionValues) | String(string)
  @unboxed type animate = Animate(motionValues) | String(string)
  @unboxed type exit = Exit(motionValues) | String(string)
  @unboxed type show = Show(motionValues) | String(string)
  @unboxed type hidden = Hidden(motionValues) | String(string)

  type variants = {
    show?: show,
    hidden?: hidden,
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
      ~onDrag: ('event, Drag.info) => unit=?,
      ~onDragStart: ('a, Drag.info) => unit=?,
      ~onDragEnd: ('event, Drag.info) => unit=?,
      ~dragControls: Drag.Controls.t<'a>=?,
      ~dragElastic: Drag.dragElastic=?,
      ~dragTransition: Drag.inertiaOptions=?,
      ~onPan: ('event, Pan.info) => unit=?,
      ~onPanEnd: ('event, Pan.info) => unit=?,
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
  module Span = {
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
      ~onDrag: ('event, Drag.info) => unit=?,
      ~onDragStart: ('a, Drag.info) => unit=?,
      ~onDragEnd: ('event, Drag.info) => unit=?,
      ~dragControls: Drag.Controls.t<'a>=?,
      ~dragElastic: Drag.dragElastic=?,
      ~dragTransition: Drag.inertiaOptions=?,
      ~onPan: ('event, Pan.info) => unit=?,
      ~onPanEnd: ('event, Pan.info) => unit=?,
    ) => React.element = "span"
  }

  module Circle = {
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
      ~cx: string=?,
      ~cy: string=?,
      ~r: string=?,
      ~strokeWidth: string=?,
      ~stroke: string=?,
      ~fill: string=?,
      ~strokeDashoffset: string=?,
      ~strokeDasharray: string=?,
      ~strokeOpacity: string=?,
    ) => React.element = "circle"
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
