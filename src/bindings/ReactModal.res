type t = React.element

type style = {
  content?: ReactDOM.Style.t,
  overlay?: ReactDOM.Style.t,
}

@react.component @module("react-modal")
external make: (
  ~className: string=?,
  ~style: style=?,
  ~children: React.element,
  ~isOpen: bool,
  ~onRequestClose: 'a => unit,
  ~contentLabel: string=?,
  ~shouldCloseOnOverlayClick: bool=?,
  ~onAfterClose: unit => unit=?,
  ~parentSelector: unit => unit=?,
) => t = "default"

@module("react-modal")
external setAppElement: string => unit = "setAppElement"
