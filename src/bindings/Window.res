type t = Dom.window

module ScrollTo = {
  type behavior =
    | @as("smooth") Smooth
    | @as("auto") Auto

  type options = {
    top?: int,
    left?: int,
    bottom?: int,
    right?: int,
    behavior?: behavior,
  }
  @send external make: (t, int, int) => unit = "scrollTo"
  @send external makeWithOptions: (t, options) => unit = "scrollTo"
}

@send
external addEventListener: (Dom.window, [#resize], 'a => unit) => unit = "addEventListener"
@send
external removeEventListener: (Dom.window, [#resize], 'a => unit) => unit = "removeEventListener"
@get external innerWidth: Dom.window => int = "innerWidth"
