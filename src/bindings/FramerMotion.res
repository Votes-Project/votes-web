type point2D = {x: float, y: float}
type boundingBox2D = {top?: int, left?: int, right?: int, bottom?: int}
type boundingBox2DFloat = {top?: float, left?: float, right?: float, bottom?: float}

type t

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
  border?: string,
  strokeDashoffset?: int,
  padding?: string,
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

module Gestures = {
  module Pan = {
    type info = {point: point2D, delta: point2D, offset: point2D, velocity: point2D}
    type panProps<'event> = {
      onPan?: ('event, info) => unit,
      onPanEnd?: ('event, info) => unit,
    }
  }

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

    @unboxed
    type dragConstraints =
      | False
      | Box(boundingBox2DFloat)

    module Controls = {
      type options = {snapToCursor?: bool, snapToOrigin?: bool, threshold?: int}
      type t<'event> = {start: ('event, ~options: options=?) => unit, stop: unit => unit}
      @module("framer-motion") external use: unit => t<'event> = "useDragControls"
    }

    type dragProps<'event> = {
      drag?: t,
      whileDrag?: variants,
      dragSnapToOrigin?: bool,
      dragConstraints?: dragConstraints,
      dragMomentum?: bool,
      dragControls?: Controls.t<'event>,
      dragElastic?: dragElastic,
      dragTransition?: inertiaOptions,
      dragListener?: bool,
    }
  }
}

type motionStyle = {y?: t, ...JsxDOMStyle.t}

type motionProps<'event> = {
  layoutId?: string,
  layout?: layout,
  variants?: variants,
  initial?: initial,
  animate?: animate,
  exit?: exit,
  transition?: transition,
  style?: motionStyle,
  className?: string,
  children?: React.element,
  cx?: string,
  cy?: string,
  r?: string,
  fill?: string,
  stroke?: string,
  strokeDashoffset?: string,
  strokeDasharray?: string,
  onClick?: 'event => unit,
  onMouseEnter?: 'event => unit,
  onMouseLeave?: 'event => unit,
  onMouseDown?: 'event => unit,
  onMouseUp?: 'event => unit,
  onMouseMove?: 'event => unit,
  onMouseOver?: 'event => unit,
  onMouseOut?: 'event => unit,
  onMouseWheel?: 'event => unit,
  onDrag?: 'event => unit,
  onDragEnd?: 'event => unit,
  onDragStart?: 'event => unit,
  ref?: ReactDOM.domRef,
}

type gestureFramerMotionProps<'event> = {
  ...motionProps<'event>,
  ...Gestures.Drag.dragProps<'event>,
  ...Gestures.Pan.panProps<'event>,
}

module Event = {
  type event =
    | @as("change") Change
    | @as("animationStart") AnimationStart
    | @as("animationComplete") AnimationComplete
    | @as("animationCancel") AnimationCancel
  @module("framer-motion")
  external use: (t, event, 'event => unit) => unit = "useMotionValueEvent"
}

@module("framer-motion") external use: 'value => t = "useMotionValue"
@send external set: (t, 'value) => unit = "set"
@send external get: t => 'value = "get"
@send external on: (t, Event.event, 'event => unit) => unit = "on"

module Frame = {
  @module("framer-motion") @scope("frame") external render: (unit => unit) => unit = "render"
}

module Spring = {
  type config = {
    stiffness?: int,
    damping?: int,
    mass?: float,
    easing?: ease,
  }

  @module("framer-motion") external use: ('value, ~config: config=?) => t = "useSpring"
}
module Div = {
  @react.component(: gestureFramerMotionProps<'event>) @module("framer-motion") @scope("motion")
  external make: unit => React.element = "div"
}

module Button = {
  @react.component(: gestureFramerMotionProps<'event>) @module("framer-motion") @scope("motion")
  external make: unit => React.element = "button"
}

module Li = {
  @react.component(: gestureFramerMotionProps<'event>) @module("framer-motion") @scope("motion")
  external make: unit => React.element = "li"
}
module Nav = {
  @react.component(: gestureFramerMotionProps<'event>) @module("framer-motion") @scope("motion")
  external make: unit => React.element = "nav"
}
module Span = {
  @react.component(: gestureFramerMotionProps<'event>) @module("framer-motion") @scope("motion")
  external make: unit => React.element = "span"
}

module Circle = {
  @react.component(: motionProps<'event>) @module("framer-motion") @scope("motion")
  external make: unit => React.element = "circle"
}

module Transform = {
  type transformer<'value, 'mappedValue> = 'value => 'mappedValue
  type options = {ease?: ease, clamp?: bool}
  @module("framer-motion")
  external make: (
    ~input: array<'value>,
    ~output: array<'mappedValue>,
    ~options: options,
  ) => transformer<'value, 'mappedValue> = "transform"
  @module("framer-motion") external use: 'value => t = "useTransform"
  @module("framer-motion")
  external useMap: (
    t,
    ~input: array<'value>,
    ~output: array<'mappedValue>,
    ~options: options,
  ) => t = "useTransform"
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

module InView = {
  type stop = unit => unit
  @module("framer-motion")
  external makeWithSelector: (string, ~info: Dom.element => unit=?) => stop = "useInView"
  @module("framer-motion")
  external makeWithElement: (Dom.element, ~info: Dom.element => unit=?) => stop = "inView"
}

let inViewWithElement = InView.makeWithElement
let inViewWithSelector = InView.makeWithSelector
