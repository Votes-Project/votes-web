let use = (callback: unit => unit, delay) => {
  let savedCallback = React.useRef(() => ())

  // Remember the latest callback.
  React.useEffect1(() => {
    savedCallback.current = callback
    None
  }, [callback])

  // Set up the interval.
  React.useEffect1(() => {
    let tick = () => {
      savedCallback.current()
    }
    let id = setInterval(tick, delay)
    Some(() => clearInterval(id))
  }, [delay])
}
