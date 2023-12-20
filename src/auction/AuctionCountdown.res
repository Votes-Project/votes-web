module Fragment = %relay(`
  fragment AuctionCountdown_auction on Auction {
    endTime
  }
`)

let useInterval = (callback: unit => unit, delay) => {
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

@react.component
let make = (~auction) => {
  open BigInt
  let {endTime} = Fragment.use(auction)

  let (secondsRemaining, setSecondsRemaining) = React.useState(_ => {
    endTime
    ->sub(BigInt.fromFloat(Date.now()))
    ->div(BigInt.fromInt(1000))
  })

  useInterval(() => {
    if secondsRemaining > fromInt(0) {
      setSecondsRemaining(_ => secondsRemaining->sub(BigInt.fromInt(1)))
    }
  }, 1000)

  let totalMinutesRemaining = secondsRemaining->div(BigInt.fromInt(60))
  let seconds = secondsRemaining->BigInt.mod(fromInt(60))
  let minutes = totalMinutesRemaining->BigInt.mod(fromInt(60))
  let hours = totalMinutesRemaining->div(fromInt(60))

  <div className="flex lg:flex-col items-start justify-between">
    {<>
      <p className="font-bold text-xl text-background-dark lg:text-active">
        {"Time Left"->React.string}
      </p>
      <p className="font-bold text-xl lg:text-3xl text-default-darker">
        {`${hours->BigInt.toString}h
      ${minutes->BigInt.toString}m
      ${seconds->BigInt.toString}s`->React.string}
      </p>
    </>}
  </div>
}
