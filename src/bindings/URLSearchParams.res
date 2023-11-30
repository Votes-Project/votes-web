type t

@new external make: (~params: {..}=?) => t = "URLSearchParams"
@send external append: (t, string, string) => unit = "append"
@send external toString: t => string = "toString"
