module Fragment = %relay(`
  fragment AuctionCurrentBid_auction on Auction {
    amount
  }
  `)

@react.component
let make = (~auction) => {
  let {amount} = Fragment.use(auction)

  <div className="flex lg:flex-col items-start justify-between">
    <p className="font-semibold text-xl lg:text-active text-background-dark ">
      {"Current Bid"->React.string}
    </p>
    <p className="font-bold text-xl lg:text-3xl text-default-darker">
      {"Ξ "->React.string}
      {amount
      ->Viem.formatEther
      ->React.string}
    </p>
  </div>
}
