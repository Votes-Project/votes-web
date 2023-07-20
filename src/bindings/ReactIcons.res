type t = Jsx.element
module LuMenu = {
  @react.component @module("react-icons/lu")
  external make: (
    ~size: string=?,
    ~color: string=?,
    ~onClick: unit => unit=?,
    ~className: string=?,
  ) => t = "LuMenu"
}

module LuCalendarCheck = {
  @react.component @module("react-icons/lu")
  external make: (
    ~size: string=?,
    ~color: string=?,
    ~onClick: unit => unit=?,
    ~className: string=?,
  ) => t = "LuCalendarCheck"
}
module LuCheckCircle = {
  @react.component @module("react-icons/lu")
  external make: (
    ~size: string=?,
    ~color: string=?,
    ~onClick: unit => unit=?,
    ~className: string=?,
  ) => t = "LuCheckCircle"
}
module LuHistory = {
  @react.component @module("react-icons/lu")
  external make: (
    ~size: string=?,
    ~color: string=?,
    ~onClick: unit => unit=?,
    ~className: string=?,
  ) => t = "LuHistory"
}
