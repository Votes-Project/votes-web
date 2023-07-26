module Query = %relay(`
  query QuestionsQuery {
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
  <div>
    <h1> {"Questions"->React.string} </h1>
  </div>
}
