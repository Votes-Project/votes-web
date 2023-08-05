%%raw(`
import viteLogo from "/vite.svg";
`)

module Query = %relay(`
  query MainQuery {
    auctionCreateds(first: 1, orderBy: tokenId, orderDirection: desc)
      @connection(key: "Main_auctionCreateds_auctionCreateds") {
      edges {
        node {
          id
          tokenId
        }
      }
    }
  }
`)

type arrowDirection = LeftPress | RightPress
exception InvalidRoute
@react.component @relay.deferredComponent
let make = (~queryRef, ~children) => {
  let {push} = RelayRouter.Utils.useRouter()
  let auctionCreatedEdges = switch Query.usePreloaded(~queryRef) {
  | {auctionCreateds: Some({edges})} => edges->Option.getWithDefault([])
  | _ => []
  }

  let todaysAuction =
    auctionCreatedEdges
    ->Array.get(0)
    ->Option.flatMap(edge => edge->Option.flatMap(edge => edge.node))
  let todaysTokenId = todaysAuction->Option.map(auction => auction.tokenId)

  let todaysDate = Date.make()->Date.toDateString
  let {queryParams} = Routes.Main.Auction.Route.useQueryParams()
  let tokenId = switch queryParams.tokenId
  ->Option.getWithDefault(todaysTokenId->Option.getExn)
  ->Int.fromString {
  | Some(tokenId) => tokenId
  | None => raise(InvalidRoute)
  }

  let handleArrowPress = direction => {
    switch direction {
    | LeftPress => Routes.Main.Auction.Route.makeLink(~tokenId=Int.toString(tokenId - 1))->push
    | RightPress => Routes.Main.Auction.Route.makeLink(~tokenId=Int.toString(tokenId + 1))->push
    }
  }

  <>
    <div className="wrapper flex flex-col">
      <Header />
      <div className="flex flex-col bg-secondary lg:flex-row">
        <div className="mx-[10%) mt-8 w-[80%] self-end md:mx-[15%] md:w-[70%] lg:w-full">
          <div className="relative h-0 w-full pt-[100%]">
            <img
              className="absolute left-0 top-0 h-auto w-full align-middle " src={%raw("viteLogo")}
            />
          </div>
          <div />
        </div>
        <main
          className="min-h-[558px] w-full !self-end bg-background pr-[5%] pb-0 pt-[5%] lg:bg-secondary lg:pr-20 ">
          <div className="!self-start p-4">
            <div className="flex items-center pt-5">
              <div className="flex gap-2">
                <button
                  disabled={tokenId == 0}
                  onClick={_ => handleArrowPress(LeftPress)}
                  className="flex h-8 w-8 items-center justify-center rounded-full bg-primary ">
                  {"⬅️"->React.string}
                </button>
                <button
                  onClick={_ => handleArrowPress(RightPress)}
                  className="flex h-8 w-8 items-center justify-center rounded-full bg-primary ">
                  {"➡️"->React.string}
                </button>
                <p> {todaysDate->React.string} </p>
              </div>
            </div>
            {children}
          </div>
        </main>
      </div>
    </div>
    {<>
      <section>
        <div className="flex flex-col">
          <h1> {"The Daily Vote"->React.string} </h1>
          <p>
            {" Each day ushers in a fresh Vote, ripe with the potential for a new question. Remember, the early bird snags the juiciest worm - earlier Votes have priority over later Votes. So rise and shine, folks!

What Does a Vote Token Represent?
HODL
Join the revolution, folks! Secure a Votes NFT in our daily auction and become part of BrightID’s global brigade. As each day rolls by, our network expands, and so does the ripple of your impact. Hold onto your Vote, and watch your influence grow!

SURVEY
Cast your query to the cosmos! All BrightID Verified Users have their ears to the ground, waiting for your question. Invest your vote wisely, and let your query echo around the world!

EDUCATE
Remember, knowledge is the key to the kingdom! With each response to your question, you’re spreading valuable insights, providing feedback, or sharing your two cents. Let’s embark on this journey of learning together, one Vote at a time!

"->React.string}
          </p>
        </div>
        <div />
      </section>
      <section>
        <div className="flex flex-col">
          <h1> {"Flash Votes in a Jiffy"->React.string} </h1>
          <p>
            {"
Got a query that needs the limelight pronto? Votes has just the ticket! Every 5 days starting with Vote 0, we sell a Flash Vote (e.g. 0, 5, 10, 15, and so on). A Flash Vote zips straight to the top of the queue if used immediately, and beats out Regular Votes in the long haul, too. It’s your fast pass to the headlines, so grab a Flash Vote and let your question take center stage!
"->React.string}
          </p>
        </div>
      </section>
      <section>
        <div className="flex flex-col">
          <h1> {"Pouring into the Community Pot!"->React.string} </h1>
          <p>
            {"


Every question posed, every Vote snagged, pours into the Bright DAO’s community pool! It’s a win-win, folks. As you make your voice heard on Votes, you’re also filling up the coffers that fuel our Bright Token!

"->React.string}
          </p>
        </div>
      </section>
      <section>
        <div className="flex flex-col">
          <h1> {"A Hot-Off-The-Press Keepsake!"->React.string} </h1>
          <p>
            {"
Every Vote token ain’t just a question, it’s a one-of-a-kind piece of history, fresh from the press! Each token is adorned with the day’s question and a dash of chosen answers. Keep a slice of the day’s heartbeat, immortalized in digital ink. Stand out with your unique token, a memento of the day you let your voice ring out!

Your Lucky Number is Up!
Every 10th day, folks, we’re stirring the pot with a raffle! The rules are simple: the more questions you answer, the more tickets you nab, and the better your chances of bagging a Votes token! So step right up, don’t be shy, and let the wheels of fortune spin!

The Community Queue Keeps the Show Going
Out of Votes but brimming with questions? No sweat! The Votes stage never dims, thanks to our trusty backup - the Community Queue. Curated from our bustling Discord channel by our savvy team, these gems ensure that Votes never misses a beat!

Step Right Up, Share Your Take!
Roll up, roll up! At Votes, your two cents isn’t spare change, it’s your golden ticket! Each day, step up to the plate and share your wise take on the question of the day. But hold your horses, there’s more! Each response earns you a spot in the grand raffle. So come on, don’t be shy, share your take, and you might just stride off a winner!
"->React.string}
          </p>
        </div>
      </section>
    </>}
  </>
}
