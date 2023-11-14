module Item = {
  module Fragment = %relay(`
    fragment Raffles_Item on Vote {
      tokenId
    }`)

  @react.component
  let make = (~raffle) => {
    let {tokenId} = Fragment.use(raffle)
    let date = Date.make()->Date.toLocaleDateStringWithLocaleAndOptions("en-US", {dateStyle: #long})
    <RelayRouter.Link
      to_={Routes.Main.Vote.Auction.Route.makeLink(~tokenId=tokenId->BigInt.toString)}>
      <div
        className="rounded-lg flex flex-row  bg-default-dark lg:bg-default-light text-white lg:text-default-darker shadow-lg lg:hover:scale-105 p-4 w-full justify-around items-center ">
        <div className="self-start">
          <div className="text-default lg:text-default-darker text-xs"> {date->React.string} </div>
        </div>
        <div className="flex-1 p-2">
          <div> {`tokenId: ${tokenId->BigInt.toString}`->React.string} </div>
        </div>
      </div>
    </RelayRouter.Link>
  }
}

module List = {
  module Fragment = %relay(`
    fragment Raffles_List on Query
    @argumentDefinitions(
      votesContractAddress: { type: "String!" }
      first: { type: "Int", defaultValue: 1000 }
      after: { type: "String" }
      orderDirection: { type: "OrderDirection", defaultValue: desc }
    ) {
      raffles(
        votesContractAddress: $votesContractAddress
        first: $first
        after: $after
        orderDirection: $orderDirection
      ) @connection(key: "Raffles_raffles") {
        edges {
          node {
            id
            ...Raffles_Item
          }
        }
      }
    }

`)
  @react.component
  let make = (~raffles) => {
    let {raffles} = Fragment.use(raffles)

    <div
      className="pb-9 px-4 flex flex-col max-h-[576px] overflow-auto gap-y-4 hide-scrollbar justify-center items-center">
      {raffles
      ->Fragment.getConnectionNodes
      ->Array.map(raffle => <Item raffle={raffle.fragmentRefs} key=raffle.id />)
      ->React.array}
    </div>
  }
}

module Query = %relay(`
query RafflesQuery($votesContractAddress: String!) {
  ...Raffles_List @arguments(votesContractAddress: $votesContractAddress)
}
`)

module RafflesCountdown = {
  @react.component
  let make = (~raffleDate) => {
    open BigInt

    let (secondsRemaining, setSecondsRemaining) = React.useState(_ => {
      raffleDate
      ->Date.getTime
      ->BigInt.fromFloat
      ->sub(BigInt.fromFloat(Date.now()))
      ->div(BigInt.fromInt(1000))
    })

    Interval.use(() => {
      if secondsRemaining > fromInt(0) {
        setSecondsRemaining(_ => secondsRemaining->sub(BigInt.fromInt(1)))
      }
    }, 1000)

    let totalMinutesRemaining = secondsRemaining->div(BigInt.fromInt(60))
    let seconds = secondsRemaining->BigInt.mod(fromInt(60))
    let minutes = totalMinutesRemaining->BigInt.mod(fromInt(60))
    let hours = totalMinutesRemaining->div(fromInt(60))

    <div className="flex lg:flex-col items-center justify-between w-full">
      {<>
        <p className="font-bold text-xl text-background-dark lg:text-active">
          {"Next Raffle"->React.string}
        </p>
        <p className="font-bold text-xl lg:text-3xl text-default-darker">
          {`${hours->BigInt.toString}h
      ${minutes->BigInt.toString}m
      ${seconds->BigInt.toString}s`->React.string}
        </p>
      </>}
    </div>
  }
}

module RaffleStats = {
  @react.component
  let make = () => {
    let {verification} = React.useContext(VerificationContext.context)

    let {setParams} = Routes.Main.Raffles.Route.useQueryParams()
    let handleLinkBrightId = _ => {
      setParams(
        ~removeNotControlledParams=false,
        ~navigationMode_=Push,
        ~shallow=false,
        ~setter=c => {
          {
            ...c,
            linkBrightID: Some(0),
          }
        },
      )
    }
    <div
      className="lg:w-[50%] w-[80%] md:w-[70%] mx-[10%] md:mx-[15%] lg:mx-0 flex align-end lg:pr-20 min-h-[420px] h-[420px]">
      <div className="w-full h-full flex flex-col items-center  p-4">
        <header className="pb-4 w-full px-4 ">
          <h1 className="text-6xl font-bold text-default-darker "> {"Raffle X"->React.string} </h1>
        </header>
        {switch verification {
        | Some(Verification(_)) =>
          <>
            <div className="flex flex-1 flex-col items-center w-full justify-center">
              <p className="font-bold text-2xl lg:text-active text-default-darker ">
                {"% of tickets"->React.string}
              </p>
              <p className="font-bold font-fugaz text-5xl text-default-darker">
                {"3%"->React.string}
              </p>
            </div>
            <div
              className="flex flex-col lg:flex-row gap-2 lg:gap-5 w-full justify-center items-center">
              <div className="flex lg:flex-col items-center justify-between w-full">
                <p className="font-bold text-xl lg:text-active text-background-dark ">
                  {"Raffle Tickets"->React.string}
                </p>
                <p
                  className="flex flex-row items-center gap-2 font-bold text-xl lg:text-3xl text-default-darker">
                  <ReactIcons.LuTicket />
                  {BigInt.fromInt(0)
                  ->Viem.formatEther
                  ->React.string}
                </p>
              </div>
              <div className="w-0 rounded-lg lg:border-primary h-5/6 border hidden lg:flex" />
              <RafflesCountdown raffleDate={Date.make()} />
            </div>
          </>
        | _ =>
          <div
            className="w-full h-full flex flex-col items-center justify-center text-center [text-wrap:balance]">
            <p className="text-lg font-bold ">
              {"You must be verified with BrightID to be eligible for raffles"->React.string}
            </p>
            <button
              onClick={handleLinkBrightId}
              className="bg-active hover:scale-105 transition-all text-white font-bold py-2 px-4 rounded mt-4">
              {"Link BrightID"->React.string}
            </button>
          </div>
        }}
      </div>
    </div>
  }
}

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let {fragmentRefs} = Query.usePreloaded(~queryRef)

  let {setHeroComponent} = React.useContext(HeroComponentContext.context)
  React.useEffect1(() => {
    setHeroComponent(_ => <RaffleStats />)
    None
  }, [setHeroComponent])

  <React.Suspense fallback={<div />}>
    <List raffles={fragmentRefs} />
  </React.Suspense>
}
