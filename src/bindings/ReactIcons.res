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

module LuArrowLeft = {
  @react.component @module("react-icons/lu")
  external make: (
    ~size: string=?,
    ~color: string=?,
    ~onClick: unit => unit=?,
    ~className: string=?,
  ) => t = "LuArrowLeft"
}
module LuArrowRight = {
  @react.component @module("react-icons/lu")
  external make: (
    ~size: string=?,
    ~color: string=?,
    ~onClick: unit => unit=?,
    ~className: string=?,
  ) => t = "LuArrowRight"
}

module LuVote = {
  @react.component @module("react-icons/lu")
  external make: (
    ~size: string=?,
    ~color: string=?,
    ~onClick: unit => unit=?,
    ~className: string=?,
  ) => t = "LuVote"
}

module LuChevronDown = {
  @react.component @module("react-icons/lu")
  external make: (
    ~size: string=?,
    ~color: string=?,
    ~onClick: unit => unit=?,
    ~className: string=?,
  ) => t = "LuChevronDown"
}
module LuChevronUp = {
  @react.component @module("react-icons/lu")
  external make: (
    ~size: string=?,
    ~color: string=?,
    ~onClick: unit => unit=?,
    ~className: string=?,
  ) => t = "LuChevronUp"
}

module LuListOrdered = {
  @react.component @module("react-icons/lu")
  external make: (~size: string=?, ~color: string=?, ~className: string=?) => t = "LuListOrdered"
}

module LuAward = {
  @react.component @module("react-icons/lu")
  external make: (~size: string=?, ~color: string=?, ~className: string=?) => t = "LuAward"
}

module LuInfo = {
  @react.component @module("react-icons/lu")
  external make: (~size: string=?, ~color: string=?, ~className: string=?) => t = "LuInfo"
}
