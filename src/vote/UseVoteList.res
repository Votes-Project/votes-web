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
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    owner: { type: "String" }
  )
  @refetchable(queryName: "UseVoteListVotesQuery") {
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
        }
      }
    }
  }
`)
  @react.component
  let make = (~votes) => {
    let {setParams} = Routes.Main.Question.Ask.Route.useQueryParams()
    let (_, refetch) = Fragment.useRefetchable(votes)

    let _ = Wagmi.Account.use(
      ~config={
        onConnect: ({address}) =>
          setParams(
            ~removeNotControlledParams=false,
            ~navigationMode_=Replace,
            ~setter=c => {
              ...c,
              owner: Some(address),
            },
            ~onAfterParamsSet=({owner}) => {
              let _ = Fragment.makeRefetchVariables(~owner)->(refetch(~variables=_))
            },
          ),
        onDisconnect: _ =>
          setParams(
            ~removeNotControlledParams=false,
            ~navigationMode_=Replace,
            ~setter=c => {
              ...c,
              owner: None,
            },
            ~onAfterParamsSet=({owner}) => {
              let _ = Fragment.makeRefetchVariables(~owner)->(refetch(~variables=_))
            },
          ),
      },
    )
    React.null
  }
}

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let {fragmentRefs} = Query.usePreloaded(~queryRef)
  <UseVoteDisplay votes=fragmentRefs />
}
