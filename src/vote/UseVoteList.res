module Query = %relay(`
  query UseVoteListQuery(
    $owner: String
    $orderBy: OrderBy_Votes
    $orderDirection: OrderDirection
  ) {
    ...UseVoteList_votes
      @arguments(
        owner: $owner
        orderBy: $orderBy
        orderDirection: $orderDirection
      )
  }
`)
module UseVoteDisplay = {
  module Fragment = %relay(`
  fragment UseVoteList_votes on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 1000 }
    after: { type: "String", defaultValue: "" }
    orderBy: { type: "OrderBy_Votes", defaultValue: id }
    orderDirection: { type: "OrderDirection", defaultValue: asc }
    owner: { type: "String" }
  )
  @refetchable(queryName: "UseVoteListVotesQuery") {
    votes(
      first: $first
      after: $after
      orderBy: $orderBy
      orderDirection: $orderDirection
      where: { owner: $owner }
    ) @connection(key: "UseVoteList_votes") {
      __id
      edges {
        node {
          id
          tokenId
        }
      }
    }
  }
`)
  @react.component
  let make = (~votes) => {
    let {setParams} = Routes.Main.Vote.New.Route.useQueryParams()
    let (data, refetch) = Fragment.useRefetchable(votes)

    let _ = Wagmi.Account.use(
      ~config={
        onConnect: ({address, isReconnected}) => {
          setParams(
            ~removeNotControlledParams=false,
            ~navigationMode_=Replace,
            ~setter=c => {
              ...c,
              owner: Some(address),
            },
            ~onAfterParamsSet=({owner}) =>
              isReconnected
                ? ()
                : refetch(
                    ~variables=Fragment.makeRefetchVariables(~owner),
                    ~fetchPolicy=StoreOrNetwork,
                  )->ignore,
          )
        },
        onDisconnect: () =>
          setParams(
            ~removeNotControlledParams=false,
            ~navigationMode_=Replace,
            ~setter=c => {
              ...c,
              owner: None,
            },
            ~onAfterParamsSet=({owner}) =>
              refetch(
                ~variables=Fragment.makeRefetchVariables(~owner),
                ~fetchPolicy=StoreOrNetwork,
              )->ignore,
          ),
      },
    )
    <div className="flex flex-col justify-center items-center">
      {"Choose A Vote"->React.string}
      <ul className="flex flex-row justify-center items-center w-full flex-wrap hide-scrollbar">
        {switch data.votes->Fragment.getConnectionNodes {
        | [] => <div> {"No VOTE Tokens"->React.string} </div>
        | votes =>
          votes
          ->Array.map(vote =>
            <li
              key={vote.id}
              className="flex flex-col justify-center items-center mx-2  my-4 shadow-md">
              <button
                className="w-full bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded items-center justify-center ">
                <p className="font-fugaz"> {vote.tokenId->React.string} </p>
              </button>
            </li>
          )
          ->React.array
        }}
      </ul>
    </div>
  }
}

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let {fragmentRefs} = Query.usePreloaded(~queryRef)
  <UseVoteDisplay votes=fragmentRefs />
}
