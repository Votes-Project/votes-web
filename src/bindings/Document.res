type t = Dom.document

@send external getElementById: (t, string) => Dom.element = "getElementById"
