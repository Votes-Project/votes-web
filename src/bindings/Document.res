type t = Dom.document

@send external getElementById: (t, string) => Dom.element = "getElementById"

module EventListener = {
  type type_ = | @as("mousedown") Mousedown | @as("mouseup") Mouseup | @as("click") Click

  @private @send external make: (Dom.document, type_, 'a => unit) => unit = "addEventListener"
  @private @send external remove: (Dom.document, type_, 'a => unit) => unit = "removeEventListener"
}

let addEventListener = EventListener.make
let removeEventListener = EventListener.remove

@get external body: t => Dom.element = "body"
