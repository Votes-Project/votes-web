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
  external intoView: (Dom.element, ~alignToTop: bool=?) => unit = "scrollIntoView"

  @send
  external intoViewWithOptions: (Dom.element, ~options: intoViewOptions=?) => unit =
    "scrollIntoView"
}
