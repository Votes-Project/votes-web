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
}

@get external offsetWidth: t => float = "offsetWidth"
