type t = Dom.document

@send external getElementById: (t, string) => Dom.element = "getElementById"

module EventListener = {
  type type_ = | @as("mousedown") Mousedown | @as("mouseup") Mouseup

  @private @send external make: (Dom.document, type_, 'a => unit) => unit = "addEventListener"
  @private @send external remove: (Dom.document, type_, 'a => unit) => unit = "removeEventListener"
}

let addEventListener = EventListener.make
let removeEventListener = EventListener.remove
