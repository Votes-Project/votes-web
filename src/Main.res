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
  </>
}
