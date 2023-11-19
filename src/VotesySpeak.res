@react.component
let make = () => {
  let {content, setShow} = React.useContext(VotesySpeakContext.context)
  let ref = React.useRef(Nullable.null)
  let isOutside = OutsideClickHook.use(ref)
  let (isInView, setIsInView) = React.useState(_ => false)

  React.useEffect1(() => {
    if isOutside && isInView {
      setShow(_ => false)
    }
    None
  }, [isOutside])

  React.useEffect1(() => {
    setIsInView(_ => true)

    None
  }, [isInView])

  switch content {
  | None => React.null
  | Some(content) =>
    <div className="absolute top-16">
      <div
        className=" relative bg-white p-2 rounded-lg text-sm shadow-md"
        ref={ReactDOM.Ref.domRef(ref)}>
        <div
          className="absolute top-[-6px] left-10 w-0 h-0 border-x-8 border-x-transparent border-b-8 border-b-white"
        />
        <div
          className="relative w-[max-content] max-w-sm lg:max-w-xs font-mono before:absolute before:inset-0 before:animate-typewriter before:bg-white  break-words ">
          {content}
        </div>
      </div>
    </div>
  }
}
