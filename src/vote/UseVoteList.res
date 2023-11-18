module Query = %relay(`
  query UseVoteListQuery(
    $owner: String
    $orderBy: OrderBy_Votes
    $orderDirection: OrderDirection
    $voteContractAddress: String!
  ) {
    ...UseVoteListFragment
      @arguments(
        owner: $owner
        orderBy: $orderBy
        orderDirection: $orderDirection
        voteContractAddress: $voteContractAddress
      )
  }
`)
module UseVoteDisplay = {
  module Fragment = %relay(`
  fragment UseVoteListFragment on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 1000 }
    after: { type: "String", defaultValue: "" }
    orderBy: { type: "OrderBy_Votes", defaultValue: id }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    owner: { type: "String" }
    voteContractAddress: { type: "String!" }
  )
  @refetchable(queryName: "UseVoteListVotesQuery") {
    votes(
      first: $first
      after: $after
      orderBy: $orderBy
      orderDirection: $orderDirection
      where: { owner: $owner }
    ) @connection(key: "UseVotesConnection_votes") {
      __id
      edges {
        node {
          id
          tokenId
        }
      }
    }
    newestVote(voteContractAddress: $voteContractAddress) {
      tokenId
    }
  }
`)
  @react.component
  let make = (~votes) => {
    let (data, refetch) = Fragment.useRefetchable(votes)
    let {votes, newestVote} = data
    let {queryParams, setParams} = Routes.Main.Question.Ask.Route.useQueryParams()

    let handleVoteClick = (_, tokenId) => {
      let tokenId = tokenId->BigInt.toInt
      switch queryParams.useVote {
      | Some(useVote) if useVote == tokenId =>
        setParams(~navigationMode_=Replace, ~removeNotControlledParams=false, ~setter=c => {
          ...c,
          useVote: None,
        })
      | _ =>
        setParams(~navigationMode_=Replace, ~removeNotControlledParams=false, ~setter=c => {
          ...c,
          useVote: Some(tokenId),
        })
      }
    }

    let {address} = Wagmi.Account.use(
      ~config={
        onConnect: ({address, isReconnected}) => {
          isReconnected
            ? ()
            : refetch(
                ~variables=Fragment.makeRefetchVariables(~owner=Some(address)),
                ~fetchPolicy=StoreOrNetwork,
              )->ignore
        },
        onDisconnect: () =>
          refetch(
            ~variables=Fragment.makeRefetchVariables(~owner=Some("")),
            ~fetchPolicy=StoreOrNetwork,
          )->ignore,
      },
    )

    React.useEffect0(() => {
      let unwatch = Wagmi.Account.watch(({address}) =>
        refetch(
          ~variables=Fragment.makeRefetchVariables(~owner=address->Nullable.toOption),
          ~fetchPolicy=StoreOrNetwork,
        )->ignore
      )
      Some(unwatch)
    })

    if address->Nullable.toOption->Option.isNone {
      <>
        {"Connect your wallet to see your Vote tokens"->React.string}
        <RainbowKit.ConnectButton />
      </>
    } else {
      switch votes->Fragment.getConnectionNodes {
      | [] =>
        <>
          {"You don't own any Vote tokens"->React.string}
          <RelayRouter.Link
            to_={Routes.Main.Vote.Auction.Route.makeLink(
              ~tokenId=newestVote->Option.map(v => v.tokenId->BigInt.toString)->Option.getExn,
            )}>
            <button> {"Go to Auction"->React.string} </button>
          </RelayRouter.Link>
        </>
      | votes =>
        <ol
          className="flex flex-[1_1_0] items-center justify-center w-full lg:h-full flex-wrap overflow-scroll hide-sidebar   ">
          {votes
          ->Array.map(vote => {
            switch queryParams.useVote {
            | Some(useVote) if useVote == vote.tokenId->BigInt.toInt =>
              <li
                className="flex items-center justify-center h-1/5 w-1/6 text-lg p-2 m-2 bg-default-light rounded-lg text-active font-bold shadow cursor-pointer border border-active"
                key={vote.id}>
                <button
                  className="w-full h-full font-fugaz" onClick={handleVoteClick(_, vote.tokenId)}>
                  {vote.tokenId->BigInt.toString->React.string}
                </button>
              </li>
            | _ =>
              <li
                className="flex items-center justify-center h-1/5 w-1/6 text-lg p-2 m-2 bg-primary-dark rounded-lg text-white font-bold shadow cursor-pointer"
                key={vote.id}>
                <button
                  className="w-full h-full font-fugaz" onClick={handleVoteClick(_, vote.tokenId)}>
                  {vote.tokenId->BigInt.toString->React.string}
                </button>
              </li>
            }
          })
          ->React.array}
        </ol>
      }
    }
  }
}

@val @scope(("import", "meta", "env"))
external voteContractAddress: option<string> = "VITE_VOTES_CONTRACT_ADDRESS"
let voteContractAddress =
  voteContractAddress
  ->Option.map(address => address->String.toLowerCase)
  ->Option.getExn

@react.component @relay.deferredComponent
let make = () => {
  let {address} = Wagmi.Account.use()
  let {fragmentRefs} = Query.use(
    ~variables={owner: address->Nullable.toOption->Option.getWithDefault(""), voteContractAddress},
  )

  <UseVoteDisplay votes=fragmentRefs />
}
