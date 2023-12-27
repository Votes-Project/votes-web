type position = Absolute | Relative | Static | Sticky | Fixed
type context = {
  content: option<React.element>,
  setContent: (option<React.element> => option<React.element>) => unit,
  show: bool,
  setShow: (bool => bool) => unit,
  position: position,
  setPosition: (position => position) => unit,
}

let context = React.createContext({
  content: None,
  setContent: _ => (),
  show: false,
  setShow: _ => (),
  position: Fixed,
  setPosition: _ => (),
})

module Provider = {
  let make = React.Context.provider(context)
}
