@react.component @module("react-contenteditable")
external make: (
  ~id: string=?,
  ~onChange: 'a => unit=?,
  ~onBlur: 'a => unit=?,
  ~html: string,
  ~disabled: bool=?,
  ~className: string=?,
  ~onFocus: 'a => unit=?,
  ~onClick: 'a => unit=?,
  ~editablehasplaceholder: string=?,
  ~placeholder: string=?,
  ~children: React.element=?,
) => React.element = "default"
