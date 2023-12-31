type variant =
  | @as("dark") Dark
  | @as("light") Light
  | @as("success") Success
  | @as("warning") Warning
  | @as("error") Error
  | @as("info") Info

@react.component @module("react-tooltip")
external make: (
  ~anchorSelect: string,
  ~content: string=?,
  ~children: React.element=?,
  ~openOnClick: bool=?,
  ~clickable: bool=?,
  ~closeOnEsc: bool=?,
  ~variant: variant=?,
  ~className: string=?,
  ~style: ReactDOM.Style.t=?,
) => React.element = "Tooltip"
