%%raw(`
import viteLogo from "/vite.svg";
`)

module Query = %relay(`
  query MainQuery {
    ...Auction_auctionCreateds
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef, ~children) => {
  let data = Query.usePreloaded(~queryRef)

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
          <React.Suspense fallback={<div> {React.string("Loading Today's Auction...")} </div>}>
            <Auction query=data.fragmentRefs />
          </React.Suspense>
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
