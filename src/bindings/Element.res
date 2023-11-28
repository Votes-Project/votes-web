type t = Dom.element
module Scroll = {
  type behavior =
    | @as("smooth") Smooth
    | @as("auto") Auto
    | @as("instant") Instant

  type block =
    | @as("start") Start
    | @as("center") Center
    | @as("end") End
    | @as("nearest") Nearest

  type inline =
    | @as("start") Start
    | @as("center") Center
    | @as("end") End
    | @as("nearest") Nearest

  type intoViewOptions = {behavior?: behavior, block?: block, inline?: inline}

  @send
  external intoView: (t, ~alignToTop: bool=?) => unit = "scrollIntoView"

  @send
  external intoViewWithOptions: (t, ~options: intoViewOptions=?) => unit = "scrollIntoView"

  @get external top: t => float = "scrollTop"
  @set external setTop: (t, float) => unit = "scrollTop"
  @get external left: t => float = "scrollLeft"
  @set external setLeft: (t, float) => unit = "scrollLeft"
  @get external width: t => float = "scrollWidth"
  @get external height: t => float = "scrollHeight"
}

module Offset = {
  @get external top: t => float = "offsetTop"
  @get external width: t => float = "offsetWidth"
  @get external height: t => float = "offsetHeight"
  @get external left: t => float = "offsetLeft"
}

module Style = {
  @get external top: t => float = "top"
  @set external setTop: (Dom.element, float) => unit = "top"
  @get external left: t => float = "left"
  @set external setLeft: (Dom.element, float) => unit = "left"
  @get external width: t => float = "width"
  @set external setWidth: (Dom.element, float) => unit = "width"
  @get external height: t => float = "height"
  @set external setHeight: (Dom.element, float) => unit = "height"
  @get external scale: t => float = "scale"
  @set external setScale: (Dom.element, float) => unit = "scale"
  @get external overflow: t => string = "overflow"
  @set external setOverflow: (Dom.element, string) => unit = "overflow"
}

@get external parentNode: t => Dom.element = "parentNode"
@get external clientHeight: t => float = "clientHeight"

module EventListener = {
  type type_ =
    | @as("resize") Resize
    | @as("scroll") Scroll
    | @as("click") Click
    | @as("wheel") Wheel
    | @as("touchstart") TouchStart
    | @as("touchmove") TouchMove
    | @as("touchend") TouchEnd
  type options = {passive: bool}

  @private @send
  external make: (t, type_, 'a => unit, ~options: options=?) => unit = "addEventListener"
  @private @send external remove: (t, type_, 'a => unit) => unit = "removeEventListener"
}
