type t = Dom.window

module Scroll = {
  @get external top: t => float = "scrollTop"
  @set external setTop: (t, float) => unit = "scrollTop"
  @get external width: t => float = "scrollWidth"
  @get external height: t => float = "scrollHeight"
}

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
  type type_ =
    | @as("resize") Resize
    | @as("scroll") Scroll
    | @as("click") Click
    | @as("wheel") Wheel
  type options = {passive: bool}

  @private @send
  external make: (Dom.window, type_, 'a => unit, ~options: options=?) => unit = "addEventListener"
  @private @send external remove: (Dom.window, type_, 'a => unit) => unit = "removeEventListener"
}

let addEventListener = EventListener.make
let removeEventListener = EventListener.remove

@get external scrollY: Dom.window => float = "scrollY"

@send external clearTimeout: (t, timeoutId) => unit = "clearTimeout"

module Width = {
  type size = XS(int) | SM(int) | MD(int) | LG(int) | XL(int) | XXL(int)
  module Inner = {
    @get external make: Dom.window => int = "innerWidth"
    let use = () => {
      let (width, setWidth) = React.useState(_ => window->make)

      let handleWindowSizeChange = React.useCallback(() => {
        setWidth(_ => window->make)
      })
      React.useEffect0(() => {
        window->addEventListener(Resize, handleWindowSizeChange)

        Some(() => window->removeEventListener(Resize, handleWindowSizeChange))
      })

      switch width {
      | width if width < 640 => XS(width)
      | width if width < 768 => SM(width)
      | width if width < 1024 => MD(width)
      | width if width < 1280 => LG(width)
      | width if width < 1536 => XL(width)
      | _ => XXL(width)
      }
    }
  }
}
let innerWidth = Width.Inner.make

module Height = {
  module Inner = {
    @get external make: Dom.window => int = "innerHeight"
  }
}

module Location = {
  type t
  external make: Dom.window => t = "location"
  @get external href: t => string = "href"
  @set external setHref: (t, string) => unit = "href"
  @send external reload: t => unit = "reload"
}
let location = Location.make

let innerHeight = Height.Inner.make
