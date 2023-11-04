@react.component
let make = () => {
  let {content, setContent} = React.useContext(VotesySpeakContext.context)
  let ref = React.useRef(Nullable.null)
  let isOutside = OutsideClickHook.use(ref)

  React.useEffect1(() => {
    if isOutside {
      setContent(_ => "")
    }
    None
  }, [isOutside])

  switch content {
  | "" => React.null
  | content =>
    <div className="absolute top-14">
      <div
        className=" relative bg-white p-2 rounded-lg text-sm shadow-md"
        ref={ReactDOM.Ref.domRef(ref)}>
        <div
          className="absolute top-[-6px] left-10 w-0 h-0 border-x-8 border-x-transparent border-b-8 border-b-white"
        />
        <p
          className="pointer-events-none relative w-[max-content] max-w-[10rem] lg:max-w-xs font-mono before:absolute before:inset-0 before:animate-typewriter before:bg-white  break-words ">
          {content->React.string}
        </p>
      </div>
    </div>
  }
}
