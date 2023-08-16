exception InvalidRoute
@react.component @relay.deferredComponent
let make = (~children) => {
  // let contextId =
  //   Dom.Storage2.localStorage->Dom.Storage2.getItem("contextId")->Option.getWithDefault("0")

  // switch verification {
  // | None => ()
  // | Some({contextIds}) =>
  //   let _ =
  //     contextIds
  //     ->Array.get(0)
  //     ->Option.map(contextId =>
  //       Dom.Storage2.localStorage->Dom.Storage2.setItem("contextId", contextId)
  //     )
  // }

  <>
    <div className="wrapper flex flex-col">
      <Header />
      <main> {children} </main>
    </div>
    {<div className="bg-background">
      <section>
        <div className="flex flex-col">
          <h1 className=" text-9xl font-bold"> {"The Daily Vote"->React.string} </h1>
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
    </div>}
  </>
}
