module Motion = {
  type initial = {
    opacity?: int,
    x?: int,
    y?: int,
    scale?: int,
    rotate?: int,
    backgroundColor?: string,
  }
  type animate = {
    opacity?: int,
    x?: int,
    y?: int,
    scale?: int,
    rotate?: int,
    backgroundColor?: string,
  }
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

  module Div = {
    @react.component @module("framer-motion") @scope("motion")
    external make: (
      ~layoutId: string=?,
      ~layout: string=?,
      ~initial: initial=?,
      ~animate: animate=?,
      ~transition: transition=?,
      ~children: React.element=?,
      ~className: string=?,
    ) => React.element = "div"
  }
}
