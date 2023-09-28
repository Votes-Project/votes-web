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
    <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold text-default-darker ">
      {`VOTE ${vote.tokenId}`->React.string}
    </h1>
    {"Raffle"->React.string}
  </>
}
