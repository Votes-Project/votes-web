@react.component
let make = (~pending) =>
  <div className="fixed flex justify-center top-0 w-full pointer-events-none z-20">
    {switch pending {
    | false => React.null
    | true => React.string("...")
    }}
  </div>
