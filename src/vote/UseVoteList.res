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
      <div className="flex flex-col items-center justify-center gap-2">
        {"Connect your wallet to see your Vote tokens"->React.string}
        <RainbowKit.ConnectButton />
      </div>
    } else {
      switch votes->Fragment.getConnectionNodes {
      | [] =>
        <div className="flex flex-col items-center justify-center gap-2">
          {"You don't own any Vote tokens"->React.string}
          <RelayRouter.Link
            to_={Routes.Main.Vote.Auction.Route.makeLink(
              ~tokenId=newestVote->Option.map(v => v.tokenId->BigInt.toString)->Option.getExn,
            )}>
            <button> {"Go to Auction"->React.string} </button>
          </RelayRouter.Link>
        </div>
      | votes =>
        <ol className="flex justify-center items-center">
          {votes
          ->Array.map(vote => {
            <li key={vote.id}> {vote.tokenId->BigInt.toString->React.string} </li>
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
