module Query = %relay(`
  query VotesQuery {
    auctionSettleds {
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
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)
  Js.log2("data: ", data)
  <div> {"Votes"->React.string} </div>
}
