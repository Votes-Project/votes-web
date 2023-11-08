module Fragment = %relay(`
 fragment Raffle_vote on Vote {
   id
   tokenId
 }

`)

@react.component
let make = (~vote) => {
  let vote = Fragment.use(vote)
  <>
    <h1 className="py-9 text-6xl text-default-darker ">
      {`VOTE ${vote.tokenId->BigInt.toString}`->React.string}
    </h1>
    {"Raffle"->React.string}
  </>
}
