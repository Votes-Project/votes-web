module VoteItem = {
  module VoteFragment = %relay(`
  fragment Votes_VoteItem_vote on Vote {
    id
    tokenId
  }
  `)

  @react.component
  let make = (~vote) => {
    let vote = VoteFragment.use(vote)
    let {setParams} = Routes.Main.Votes.Route.useQueryParams()
    let handleVoteClick = _ => {
      setParams(
        ~removeNotControlledParams=false,
        ~navigationMode_=Push,
        ~shallow=false,
        ~setter=c => c,
      )
    }

    <li
      className="rounded-xl flex flex-col items-start justify-center relative transition-all shadow-xl w-[25vw] h-1/3 lg:h-auto md:w-[20vw] lg:w-1/5 backdrop-blur-sm hover:bg-default-light lg:hover:bg-secondary"
      key=vote.id>
      <button
        className=" h-full m-0 border border-default-dark lg:border-active relative w-full cursor-pointer bg-transparent rounded-xl"
        onClick=handleVoteClick>
        <div className="w-full relative ">
          <EmptyVoteChart
            className="rounded-none my-0 mx-auto w-full h-full align-middle min-w-[100px] min-h-[100px]"
          />
        </div>
        <p
          className="bg-default-dark lg:bg-active w-full self-end rounded-b-lg font-bold text-lg text-default-light">
          {vote.tokenId->BigInt.toString->React.string}
        </p>
      </button>
    </li>
  }
}

module VoteListDisplay = {
  module VotesFragment = %relay(`
  fragment Votes_VoteListDisplay_votes on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 1000 }
    after: { type: "Cursor" }
    orderBy: { type: "Vote_orderBy", defaultValue: id }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    owner: { type: "Bytes" }
  )
  @refetchable(queryName: "VotesListQuery") {
    voteConnection(
      first: $first
      after: $after
      orderBy: $orderBy
      orderDirection: $orderDirection
      where: { owner: $owner }
    ) @connection(key: "VotesConnection_voteConnection") {
      __id
      edges {
        node {
          id
          ...Votes_VoteItem_vote
        }
      }
    }
  }
  `)

  @react.component
  let make = (~query) => {
    let (data, refetch) = VotesFragment.useRefetchable(query)

    let {queryParams, setParams} = Routes.Main.Votes.Route.useQueryParams()
    let setOwnedParam = address =>
      setParams(
        ~removeNotControlledParams=false,
        ~navigationMode_=Replace,
        ~setter=currentParameters => {
          {...currentParameters, sortBy: Owned(address->Some)->Some}
        },
        ~onAfterParamsSet=_ =>
          refetch(~variables=VotesFragment.makeRefetchVariables(~owner=Some(address)))->ignore,
      )
    let _ = Wagmi.Account.use(
      ~config={
        onConnect: ({address}) => {
          switch queryParams.sortBy {
          | Some(Owned(None)) => setOwnedParam(address)
          | _ => ()
          }
        },
        onDisconnect: _ => {
          switch queryParams.sortBy {
          | Some(Owned(Some(_))) => setOwnedParam("0x0")
          | _ => ()
          }
        },
      },
    )

    let handleSort = e => {
      let value = (e->ReactEvent.Form.target)["value"]
      let sortBy = value->VotesSortBy.parse
      if sortBy == queryParams.sortBy {
        ()
      } else {
        setParams(
          ~removeNotControlledParams=false,
          ~navigationMode_=Replace,
          ~setter=currentParameters => {...currentParameters, sortBy},
          ~onAfterParamsSet=_ => {
            let variables = switch sortBy {
            | Some(New) => VotesFragment.makeRefetchVariables(~orderDirection=Some(Desc))
            | Some(Old) => VotesFragment.makeRefetchVariables(~orderDirection=Some(Asc))
            | Some(Owned(Some(address))) => VotesFragment.makeRefetchVariables(~owner=Some(address))
            | _ => VotesFragment.makeRefetchVariables()
            }
            refetch(~variables)->ignore
          },
        )
      }
    }

    <div className="lg:max-h-[420px] relative">
      <nav className="px-4 w-full flex justify-between items-center pb-4">
        <div>
          <h1 className="font-semibold ">
            {`Explore ${data.voteConnection
              ->VotesFragment.getConnectionNodes
              ->Array.length
              ->Int.toString} Votes`->React.string}
          </h1>
        </div>
        <div>
          <label>
            <select
              value={queryParams.sortBy->Option.mapWithDefault("", VotesSortBy.serialize)}
              className="border-black/20 bg-transparent backdrop-blur-sm text-lg font-semibold rounded-xl"
              onChange={e => {
                e->handleSort
              }}>
              <option className="hidden" value=""> {"Sort By"->React.string} </option>
              <VotesSortByOptions />
            </select>
          </label>
        </div>
      </nav>
      {switch queryParams.sortBy {
      | Some(Owned(None)) =>
        <div className="flex flex-col h-full w-full items-center justify-around">
          <RainbowKit.ConnectButton />
        </div>
      | _ =>
        <ul
          className="px-4 flex flex-col lg:flex-row flex-wrap max-h-[576px] overflow-auto gap-y-4 gap-x-4 hide-scrollbar justify-center items-center pb-6">
          {data.voteConnection
          ->VotesFragment.getConnectionNodes
          ->Array.map(vote => {
            <VoteItem vote={vote.fragmentRefs} key=vote.id />
          })
          ->React.array}
        </ul>
      }}
    </div>
  }
}

@module external votesyConstruction: 'a = "/votesy_construction.svg"

module Query = %relay(`
  query VotesQuery(
    $owner: Bytes
    $orderBy: Vote_orderBy
    $orderDirection: OrderDirection
  ) {
    ...Votes_VoteListDisplay_votes
      @arguments(
        owner: $owner
        orderBy: $orderBy
        orderDirection: $orderDirection
      )
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)
  let {setHeroComponent} = React.useContext(HeroComponentContext.context)
  React.useEffect1(() => {
    setHeroComponent(_ => <>
      <div
        className="relative  lg:w-[50%] w-[80%] md:w-[70%] mx-[10%] mt-8 md:mx-[15%] lg:mx-0 flex flex-col align-end lg:pr-20 ">
        {switch Environment.featureFlags {
        | {enableCharts: false} =>
          <>
            <div
              className="absolute pointer-event-none flex flex-row items-center justify-center w-full h-full backdrop-blur-sm z-10 pointer-events-none">
              <img src={votesyConstruction["default"]} className="h-24 w-24 " alt="Vite logo" />
              <h2 className="text-2xl text-center font-semibold text-black[text-wrap:balance]">
                {"The Votes Explorer is under construction"->React.string}
              </h2>
              <img src={votesyConstruction["default"]} className="h-24 w-24 " alt="Vite logo" />
            </div>
            <div className="relative h-0 w-full pt-[100%]">
              <EmptyVoteChart className="absolute left-0 top-0 w-full align-middle " />
            </div>
          </>
        | _ =>
          <div className="relative h-0 w-full pt-[100%]">
            <EmptyVoteChart className="absolute left-0 top-0 w-full align-middle " />
          </div>
        }}
      </div>
    </>)
    None
  }, [setHeroComponent])
  <VoteListDisplay query={data.fragmentRefs} />
}
