module OwnedVoteItem = {
  module Fragment = %relay(`
  fragment OwnedVotesList_OwnedVoteItem_vote on Vote {
    id
    tokenId
    uri
  }
  `)

  @react.component
  let make = (~ownedVote) => {
    let vote = Fragment.use(ownedVote)
    let {setParams} = Routes.Main.Route.useQueryParams()

    let handleVoteClick = _ => {
      setParams(
        ~removeNotControlledParams=false,
        ~navigationMode_=Push,
        ~shallow=false,
        ~setter=c => {
          ...c,
          voteDetailsToken: vote.tokenId->Int.fromString,
        },
      )
    }

    <button className=" bg-default-light rounded-lg p-6" onClick=handleVoteClick>
      <p> {vote.tokenId->React.string} </p>
    </button>
  }
}

module OwnedVotesListDisplay = {
  module Fragment = %relay(`
 fragment OwnedVotesList_OwnedVotesListDisplay_votes on Query
 @argumentDefinitions(
   first: { type: "Int", defaultValue: 1000 }
   orderBy: { type: "OrderBy_Votes", defaultValue: id }
   orderDirection: { type: "OrderDirection", defaultValue: asc }
   owner: { type: "String" }
 ) {
   votes(
     first: $first
     orderBy: $orderBy
     orderDirection: $orderDirection
     where: { owner: $owner }
   ) @connection(key: "OwnedVotesList_votes_votes") {
     edges {
       node {
         id
         ...OwnedVotesList_OwnedVoteItem_vote
       }
     }
   }
 }
`)

  @react.component
  let make = (~votes as votesFragmentRef) => {
    let {votes} = Fragment.use(votesFragmentRef)
    <div className="h-full w-full flex flex-col py-8 items-center justify-around">
      <ul className="flex w-full p-4 justify-around items-center">
        {votes
        ->Fragment.getConnectionNodes
        ->Array.map(vote => {
          <li key={vote.id}>
            <OwnedVoteItem ownedVote={vote.fragmentRefs} />
          </li>
        })
        ->React.array}
      </ul>
      <div>
        <h2 className="text-2xl font-bold"> {"Select one of your Vote Tokens"->React.string} </h2>
      </div>
    </div>
  }
}

module Query = %relay(`
  query OwnedVotesListQuery($owner: String!) {
    ...OwnedVotesList_OwnedVotesListDisplay_votes @arguments(owner: $owner)
  }`)

@react.component @relay.deferredComponent
let make = () => {
  let {address} = Wagmi.useAccount()
  let data = switch address->Nullable.toOption {
  | Some(address) => Query.use(~variables={owner: address}, ~fetchPolicy=StoreAndNetwork)->Some
  | None => None
  }

  <div className="w-full h-full flex justify-center items-center">
    {switch data {
    | None => <RainbowKit.ConnectButton />
    | Some({fragmentRefs}) =>
      <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
        <OwnedVotesListDisplay votes={fragmentRefs} />
      </React.Suspense>
    }}
  </div>
}
