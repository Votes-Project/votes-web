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
          {vote.tokenId->React.string}
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
    ) @connection(key: "VoteListDisplay_voteTransfers_votes") {
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
    let {address} = Wagmi.useAccount()

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
          ~onAfterParamsSet=_ =>
            switch sortBy {
            | Some(New) =>
              refetch(
                ~variables=VotesFragment.makeRefetchVariables(~orderDirection=Some(Desc)),
              )->ignore
            | Some(Old) =>
              refetch(
                ~variables=VotesFragment.makeRefetchVariables(~orderDirection=Some(Asc)),
              )->ignore
            | Some(Unused) => ()
            | Some(Used) => ()
            | Some(Owned(Some(address))) =>
              refetch(~variables=VotesFragment.makeRefetchVariables(~owner=Some(address)))->ignore
            | Some(Owned(None)) => ()
            | None => ()
            },
        )
      }
    }
    let votes =
      data.votes
      ->VotesFragment.getConnectionNodes
      ->Array.map(vote => {
        <VoteItem vote={vote.fragmentRefs} key=vote.id />
      })
    <div className="pb-6">
      <nav className=" w-full flex justify-between items-center pb-4 px-2">
        <div>
          {switch voteContract {
          | Some({totalSupply}) =>
            <h1 className="font-semibold "> {`Explore ${totalSupply} Votes`->React.string} </h1>
          | None => <> </>
          }}
        </div>
        <div>
          <label>
            <select
              className="border-black/20 bg-transparent backdrop-blur-sm text-lg font-semibold rounded-xl"
              onChange={e => {
                e->handleSort
              }}>
              <option className=" hidden" key="sortby" value=""> {"Sort By"->React.string} </option>
              <option key="new" value="new"> {"New"->React.string} </option>
              <option key="old" value="old"> {"Old"->React.string} </option>
              <option key="unused" value="unused"> {"Unused"->React.string} </option>
              <option key="used" value="used"> {"Used"->React.string} </option>
              <option value={address->Nullable.toOption->Option.getWithDefault("")} key="owned">
                {"Owned"->React.string}
              </option>
            </select>
          </label>
        </div>
      </nav>
      <ul
        className="flex flex-col lg:flex-row flex-wrap max-h-[576px] overflow-auto gap-y-4 gap-x-4 hide-scrollbar justify-center items-center">
        {votes->React.array}
      </ul>
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
  <VoteListDisplay query={data.fragmentRefs} />
}
