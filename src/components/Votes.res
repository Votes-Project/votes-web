module VoteItem = {
  module VoteFragment = %relay(`
  fragment Votes_VoteItem_vote on Vote {
    id
    tokenId
    uri
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
        ~setter=c => {
          ...c,
          voteDetails: Some(0),
          voteDetailsToken: vote.tokenId->Int.fromString,
        },
      )
    }

    <li className="rounded-xl flex flex-col  justify-center items-center relative transition-all">
      <button
        className="h-full m-0 border-0 relative scroll-m-[1vh] cursor-pointer bg-secondary noise rounded-xl"
        onClick=handleVoteClick>
        <EmptyVoteChart
          className="static rounded-none max-w-none my-0 mx-auto w-full h-full align-middle"
        />
        <p
          className="bg-background-light block absolute w-full bottom-0 rounded-b-xl font-bold text-lg text-default-dark">
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
    orderBy: { type: "OrderBy_Votes", defaultValue: id }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    where: { type: "Where_Votes" }
  ) {
    votes(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
      where: $where
    ) @connection(key: "VoteListDisplay_voteTransfers_votes") {
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
    let {votes} = VotesFragment.use(query)
    let {voteContract} = VoteContractFragment.use(query)
    let votes =
      votes
      ->VotesFragment.getConnectionNodes
      ->Array.map(vote => {
        <VoteItem vote={vote.fragmentRefs} key=vote.id />
      })
    <div className="bg-background">
      <nav className=" w-full flex justify-between items-center py-4 px-2">
        <div>
          {switch voteContract {
          | Some({totalSupply}) => <p> {`Explore ${totalSupply} Votes`->React.string} </p>
          | None => <> </>
          }}
        </div>
        <div>
          <label>
            <select>
              {"Sort by"->React.string}
              <option value="tokenId"> {"Token ID"->React.string} </option>
            </select>
          </label>
        </div>
      </nav>
      <ul className="grid grid-cols-3 grid-flow-row px-2 gap-4 md:grid-cols-6">
        {votes->React.array}
      </ul>
    </div>
  }
}

module Query = %relay(`
  query VotesQuery($votesContractAddress: String!) {
    ...Votes_VoteListDisplay_votes
    ...Votes_VoteListDisplay_voteContract @arguments(id: $votesContractAddress)
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)
  <VoteListDisplay query={data.fragmentRefs} />
}
