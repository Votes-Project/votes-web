%%raw(`
import viteLogo from "/vite.svg";
`)

module Query = %relay(`
  query MainQuery{
    auctionSettleds {
      edges {
        node {
          id
          tokenId
          }
      }
    }
    questionSubmitteds {
      edges {
        node {
          id
        }
      }
    }
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef, ~children) => {
  let data = Query.usePreloaded(~queryRef)
  let (currentBid, _) = React.useState(_ => "0")
  let todaysDate = Date.make()->Date.toDateString

  <>
    <div className="wrapper flex flex-col">
      <Header />
      <div className="flex flex-col bg-background-light lg:flex-row">
        <div className="mx-[10%) mt-8 w-[80%] self-end md:mx-[15%] md:w-[70%] lg:w-full">
          <div className="relative h-0 w-full pt-[100%]">
            <img
              className="absolute left-0 top-0 h-auto w-full align-middle " src={%raw("viteLogo")}
            />
          </div>
          <div />
        </div>
        <main
          className="min-h-[558px] w-full !self-end bg-background px-[5%] pb-0 pt-[5%] lg:bg-background-light lg:pr-20 ">
          <div className="!self-start p-4">
            <div className="flex items-center pt-5">
              <div className="flex gap-2">
                <button
                  className="flex h-8 w-8 items-center justify-center rounded-full bg-primary ">
                  {"⬅️"->React.string}
                </button>
                <button
                  className="flex h-8 w-8 items-center justify-center rounded-full bg-primary ">
                  {"➡️"->React.string}
                </button>
                <p> {todaysDate->React.string} </p>
              </div>
            </div>
            <div />
            <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold lg:text-7xl">
              {"VOTE 50"->React.string}
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
          </div>
        </main>
      </div>
    </div>
    {<>
      <section>
        <div className="flex flex-col">
          <div>
            <h1>
              <p> {"One Noun, Every Day, Forever."->React.string} </p>
            </h1>
            <p>
              <p>
                {" Behold, an infinite work of art! Nouns is a community-owned
                  brand that makes a positive impact by funding ideas and
                  fostering collaboration. From collectors and technologists, to
                  non-profits and brands, Nouns is for everyone."->React.string}
              </p>
            </p>
          </div>
        </div>
        <div>
          // {
          //   /* <iframe
          //     src="https://www.youtube.com/embed/lOzCA7bZG_k"
          //     title="YouTube video player"
          //     frameBorder="0"
          //     allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          //     allowFullScreen
          //   ></iframe> */
          // }
        </div>
      </section>
      <section>
        <div className="flex flex-col">
          // {
          //   /* <iframe
          //     src="https://www.youtube.com/embed/oa79nN4gMPs"
          //     title="YouTube video player"
          //     frameBorder="0"
          //     allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          //     allowFullScreen
          //   ></iframe> */
          // }
        </div>
        <div className="flex flex-col">
          <div>
            <h1>
              <p> {"Build With Nouns. Get Funded."->React.string} </p>
            </h1>
            <p>
              <p>
                {"There’s a way for everyone to get involved with Nouns. From
                  whimsical endeavors like naming a frog, to ambitious projects
                  like constructing a giant float for the Rose Parade, or even
                  crypto infrastructure like. Nouns funds projects of all
                  sizes and domains."->React.string}
              </p>
            </p>
          </div>
        </div>
      </section>
    </>}
    {children}
  </>
}
