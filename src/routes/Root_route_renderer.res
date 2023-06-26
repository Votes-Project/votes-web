module App = {
  @react.component @module("../App.jsx") external make: unit => React.element = "default"
}
let renderer = Routes.Root.Route.makeRenderer(
  ~prepare=_ => {
    ()
  },
  ~render=_ => {
    <App />
  },
)
