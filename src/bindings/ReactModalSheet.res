type t = React.element

module Sheet = {
  type detent = | @as("content-height") ContentHeight | @as("full-height") FullHeight
  @react.component @module("react-modal-sheet")
  external make: (
    ~className: string=?,
    ~children: React.element,
    ~isOpen: bool,
    ~onClose: 'a => unit,
    ~onCloseEnd: 'a => unit=?,
    ~rootId: string=?,
    ~snapPoints: array<float>=?,
    ~detent: detent=?,
  ) => t = "default"

  module Container = {
    @react.component @module("react-modal-sheet") @scope("default")
    external make: (~className: string=?, ~children: React.element=?) => t = "Container"
  }
  module Header = {
    @react.component @module("react-modal-sheet") @scope("default")
    external make: (~className: string=?, ~children: React.element=?) => t = "Header"
  }
  module Content = {
    @react.component @module("react-modal-sheet") @scope("default")
    external make: (~className: string=?, ~children: React.element=?) => t = "Content"
  }
  module Backdrop = {
    @react.component @module("react-modal-sheet") @scope("default")
    external make: (~className: string=?, ~onTap: ReactEvent.Mouse.t => unit) => t = "Backdrop"
  }
  module Scroller = {
    type draggableAt = | @as("both") Both
    @react.component @module("react-modal-sheet") @scope("default")
    external make: (
      ~className: string=?,
      ~children: React.element=?,
      ~draggableAt: draggableAt=?,
    ) => t = "Scroller"
  }
}
