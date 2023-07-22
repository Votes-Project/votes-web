type t = React.element

module Sheet = {
  @react.component @module("react-modal-sheet")
  external make: (
    ~className: string=?,
    ~children: React.element,
    ~isOpen: bool,
    ~onClose: unit => unit,
  ) => t = "default"

  module Container = {
    @react.component @module("react-modal-sheet") @scope("default")
    external make: (~className: string=?, ~children: React.element=?) => t = "Container"
  }
  module Header = {
    @react.component @module("react-modal-sheet") @scope("default")
    external make: (~className: string=?) => t = "Header"
  }
  module Content = {
    @react.component @module("react-modal-sheet") @scope("default")
    external make: (~className: string=?, ~children: React.element=?) => t = "Content"
  }
  module Backdrop = {
    @react.component @module("react-modal-sheet") @scope("default")
    external make: (~className: string=?, ~onTap: ReactEvent.Mouse.t => unit) => t = "Backdrop"
  }
}
