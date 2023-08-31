module VoteItem = {
  @module("/assets/RadarChart.png")
  external radarChart: string = "default"
  module VoteTransferFragment = %relay(`
  fragment Votes_VoteItem_voteTransfer on VoteTransfer {
    id
    tokenId
  }
  `)

  @react.component
  let make = (~voteTransfer) => {
    let voteTransfer = VoteTransferFragment.use(voteTransfer)
    <li className="rounded-xl flex flex-col justify-center items-center relative transition-all">
      <button
        className="h-full m-0 border-0 relative aspect-square scroll-m-[1vh] cursor-pointer bg-secondary noise rounded-xl">
        <img
          className="rounded-none max-w-none my-0 mx-auto w-full align-middle"
          src=radarChart
          alt="Radar Graph"
        />
        <p
          className="bg-background-light block relative bottom-auto rounded-b-xl font-bold text-lg text-default-dark">
          {voteTransfer.tokenId->React.string}
        </p>
      </button>
    </li>
  }
}

module VoteListDisplay = {
  module VoteTransfersFragment = %relay(`
  fragment Votes_VoteListDisplay_voteTransfers on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 100 }
    orderBy: { type: "OrderBy_Transfers", defaultValue: tokenId }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
    where: {
      type: "Where_Transfers"
      defaultValue: { from: "0x0000000000000000000000000000000000000000" }
    }
  ) {
    voteTransfers(
      orderBy: $orderBy
      orderDirection: $orderDirection
      first: $first
      where: $where
    ) @connection(key: "VoteListDisplay_voteTransfers_voteTransfers") {
      edges {
        node {
          id
          tokenId
          ...Votes_VoteItem_voteTransfer
        }
      }
    }
  }
  `)

  @react.component
  let make = (~query) => {
    let {voteTransfers} = VoteTransfersFragment.use(query)
    let votes =
      voteTransfers
      ->VoteTransfersFragment.getConnectionNodes
      ->Array.map(voteTransfer => {
        <VoteItem voteTransfer={voteTransfer.fragmentRefs} key=voteTransfer.id />
      })
    <div className="bg-background">
      <nav className=" w-full flex justify-between items-center py-4 px-2">
        <div>
          <p> {"Explore x Votes"->React.string} </p>
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
  query VotesQuery {
    ...Votes_VoteListDisplay_voteTransfers
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)
  <VoteListDisplay query={data.fragmentRefs} />
}
