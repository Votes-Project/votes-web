module Fragment = %relay(`
 fragment Raffle_vote on Vote {
   id
   tokenId
   owner
 
   ...BlockExplorerButton_vote
 }
`)

@react.component
let make = (~vote) => {
  let {owner, tokenId, fragmentRefs} = Fragment.use(vote)
  <>
    <h1 className="py-9 text-6xl text-default-darker ">
      {`VOTE ${tokenId->BigInt.toString}`->React.string}
    </h1>
    <div className="flex flex-col lg:flex-row lg:gap-5 gap-2">
      <div className="flex lg:flex-col itemsa-start justify-between">
        <p className="font-medium text-xl lg:text-active text-background-dark">
          {"Raffle Winner"->React.string}
        </p>
        <p className="font-bold text-xl lg:text-3xl text-default-darker">
          <ShortAddress address={Some(owner)} />
        </p>
      </div>
      <div className="w-0 rounded-lg lg:border-primary border hidden lg:flex" />
      <div className="flex lg:flex-col items-start justify-between">
        <p className="font-medium text-xl text-background-dark lg:text-active">
          {"Held By"->React.string}
        </p>
        <p className="font-bold text-xl lg:text-3xl text-default-darker">
          <ShortAddress address={Some(owner)} />
        </p>
      </div>
    </div>
    <div className="flex py-4 gap-4">
      <BlockExplorerButton vote={fragmentRefs} />
    </div>
    <div className="flex flex-col w-full items-center justify-center px-8 text-lg">
      <p className="p-4">
        {"This Vote is set aside to be raffled to our wonderful community who participate in the daily Vote.
          Results are decided using the points accumulated over participation in the last 9 votes cycle, using the Chainlink ETF to determine a winner.
          Vote Raffles are a core ethos of Votes, providing tangible incentive for daily Voters to return and participate daily.
         "->React.string}
      </p>
      <div className="w-full h-0 border " />
      <a href="" className="text-default-darker lg:text-active font-bold p-4">
        {"Go to Raffle Details"->React.string}
      </a>
    </div>
  </>
}
