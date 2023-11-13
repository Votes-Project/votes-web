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
      className="rounded-xl flex flex-col items-center justify-center relative transition-all  w-1/4 lg:w-1/5 shadow-lg"
      key=vote.id>
      <button
        className="h-full m-0 border-0 relative w-full cursor-pointer bg-default noise rounded-xl"
        onClick=handleVoteClick>
        <div className="w-full h-full align-middle">
          <EmptyVoteChart
            className=" rounded-none max-w-none my-0 mx-auto w-full h-full align-middle"
          />
        </div>
        <p
          className="bg-default-dark block absolute w-full bottom-0 rounded-b-xl font-bold text-lg text-white">
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
    after: { type: "String", defaultValue: "" }
    orderBy: { type: "OrderBy_Votes", defaultValue: id }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    owner: { type: "String" }
  )
  @refetchable(queryName: "VotesListQuery") {
    votes(
      first: $first
      after: $after
      orderBy: $orderBy
      orderDirection: $orderDirection
      where: { owner: $owner }
    ) @connection(key: "VotesConnection_votes") {
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

  module VoteContractFragment = %relay(`
  fragment Votes_VoteListDisplay_voteContract on Query
  @argumentDefinitions(id: { type: "String!" }) {
    voteContract(id: $id) {
      totalSupply
    }
  }
  `)

  @react.component
  let make = (~query) => {
    let (data, refetch) = VotesFragment.useRefetchable(query)
    let {voteContract} = VoteContractFragment.use(query)
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

    <div className="pb-6">
      <nav className="px-4 w-full flex justify-between items-center pb-4">
        <div>
          {switch voteContract {
          | Some({totalSupply}) =>
            <h1 className="font-semibold ">
              {`Explore ${totalSupply->BigInt.toString} Votes`->React.string}
            </h1>
          | None => <> </>
          }}
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
          className="px-4 flex flex-col lg:flex-row flex-wrap max-h-[576px] overflow-auto gap-y-4 gap-x-4 hide-scrollbar justify-center items-center">
          {data.votes
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

module Query = %relay(`
  query VotesQuery(
    $votesContractAddress: String!
    $owner: String
    $orderBy: OrderBy_Votes
    $orderDirection: OrderDirection
  ) {
    ...Votes_VoteListDisplay_votes
      @arguments(
        owner: $owner
        orderBy: $orderBy
        orderDirection: $orderDirection
      )
    ...Votes_VoteListDisplay_voteContract @arguments(id: $votesContractAddress)
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)
  let {setHeroComponent} = React.useContext(HeroComponentContext.context)
  React.useEffect1(() => {
    setHeroComponent(_ =>
      <div
        className=" lg:w-[50%] w-[80%] md:w-[70%] mx-[10%] mt-8 md:mx-[15%] lg:mx-0 flex align-end lg:pr-20">
        <div className="relative h-0 w-full pt-[100%]">
          <EmptyVoteChart className="absolute left-0 top-0 w-full align-middle " />
        </div>
      </div>
    )
    None
  }, [setHeroComponent])
  <VoteListDisplay query={data.fragmentRefs} />
}
