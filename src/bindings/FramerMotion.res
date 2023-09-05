module Motion = {
  module Div = {
    @react.component @module("framer-motion") @scope("motion")
    external make: (
      ~layoutId: string=?,
      ~children: React.element=?,
      ~className: string=?,
    ) => React.element = "div"
  }
}
