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
external alert: (t, string) => unit = "alert"

module EventListener = {
  type type_ = | @as("resize") Resize | @as("scroll") Scroll | @as("click") Click
  type options = {passive: bool}

  @private @send
  external make: (Dom.window, type_, 'a => unit, ~options: options=?) => unit = "addEventListener"
  @private @send external remove: (Dom.window, type_, 'a => unit) => unit = "removeEventListener"
}

let addEventListener = EventListener.make
let removeEventListener = EventListener.remove

@get external innerWidth: Dom.window => int = "innerWidth"
@get external scrollY: Dom.window => float = "scrollY"

@send external clearTimeout: (t, timeoutId) => unit = "clearTimeout"
