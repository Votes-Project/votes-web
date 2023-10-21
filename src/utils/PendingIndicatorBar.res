@react.component
let make = (~pending) =>
  <div className="flex justify-center top-1 w-full pointer-events-none z-20 fixed">
    {switch pending {
    | false => React.null
    | true => <div className="bg-active h-2 w-8 animate-pulse rounded-md" />
    }}
  </div>
