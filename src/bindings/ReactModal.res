type t = React.element
@react.component @module("react-modal")
external make: (
  ~className: string=?,
  ~children: React.element,
  ~isOpen: bool,
  ~onRequestClose: 'a => unit,
  ~conteentLabel: string=?,
) => t = "default"

@module("react-modal")
external setAppElement: string => unit = "setAppElement"
