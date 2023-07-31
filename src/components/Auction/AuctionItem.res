module AuctionItemFragment = %relay(`
  fragment AuctionItem_auctionCreated on AuctionCreated {
    id
    tokenId
  }
`)

@react.component
let make = (~auctionCreated as auctionCreatedRef, ~index) => {
  let auctionCreated = AuctionItemFragment.use(auctionCreatedRef)
  let (currentBid, _) = React.useState(_ => "0")
  switch index {
  | 0 =>
    <>
      <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold lg:text-7xl">
        {`VOTE ${auctionCreated.tokenId}`->React.string}
      </h1>
      <div className="flex flex-col ">
        <div className="flex items-center justify-between">
          <p> {"Current Bid"->React.string} </p>
          <p>
            {currentBid->React.string}
            {"Ξ"->React.string}
          </p>
        </div>
        <div className="flex items-center justify-between">
          <p> {"Time Left"->React.string} </p>
          <p> {"1h 20m 30s"->React.string} </p>
        </div>
      </div>
      <div className="flex w-full items-center justify-around gap-2 py-10">
        <input
          className="flex-1 rounded-2xl px-2 py-4 placeholder:text-lg placeholder:font-bold focus:border-sky-500 focus:outline-none focus:ring-1"
          placeholder="Ξ 0.1 or more"
          type_="number"
        />
        <button className="flex-2 rounded-lg bg-orange-500 px-3 py-2 text-center text-white">
          {"Place Bid"->React.string}
        </button>
      </div>
      <div className="flex flex-col justify-between">
        <div className="flex items-center justify-between">
          <p> {"vict0xr.eth"->React.string} </p>
          <div className="flex gap-2">
            <p> {"0.4 Ξ"->React.string} </p>
            <p> {"🔗"->React.string} </p>
          </div>
        </div>
        <div className="my-3 h-0 w-full border border-black" />
        <div className="flex items-center justify-between">
          <p> {"chilleeman.eth"->React.string} </p>
          <div className="flex gap-2">
            <p> {"0.2 Ξ"->React.string} </p>
            <p> {"🔗"->React.string} </p>
          </div>
        </div>
        <div className="my-3 h-0 w-full border border-black" />
        <div className="flex items-center justify-between">
          <p> {"adamstallard.eth"->React.string} </p>
          <div className="flex gap-2">
            <p> {"0.1 Ξ"->React.string} </p>
            <p> {"🔗"->React.string} </p>
          </div>
        </div>
        <div className="my-3 h-0 w-full border border-black" />
      </div>
      <div className="w-full py-2 text-center">
        {" View
              All
              Bids"->React.string}
      </div>
    </>
  | _ =>
    <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold lg:text-7xl">
      {`VOTE ${auctionCreated.tokenId}`->React.string}
    </h1>
  }
}
