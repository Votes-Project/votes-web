import React, { useEffect } from "react"
import { useState } from "react";
import viteLogo from "/vite.svg";
import { make as Header } from "./Header";
import { make as Test } from "./Test";

function App() {
  const [currentBid] = useState("0");
  const now = new Date();
  const todaysDate = now.toDateString();

  return (
    <>
      <div className="wrapper flex flex-col">
        <Header />
        <div className="flex flex-col bg-primary lg:flex-row">
          <div className="mx-[10%] mt-8 w-[80%] self-end md:mx-[15%] md:w-[70%] lg:w-full">
            <div className="relative h-0 w-full pt-[100%]">
              <img
                className="absolute left-0 top-0 h-auto w-full align-middle "
                src={viteLogo}
              ></img>
            </div>
            <div>{/* <chart></chart> */}</div>
          </div>

          <main className="min-h-[558px] w-full !self-end bg-background px-[5%] pb-0 pt-[5%] lg:bg-primary lg:pr-20 ">
            <div className="!self-start p-4">
              <div className="flex items-center pt-5">
                <div className="flex gap-2">
                  <button className="flex h-8 w-8 items-center justify-center rounded-full bg-primary ">
                    ⬅️
                  </button>
                  <button className="flex h-8 w-8 items-center justify-center rounded-full bg-primary ">
                    ➡️
                  </button>
                  <p> {todaysDate}</p>{" "}
                </div>
              </div>
              <div>{/* view toggle */}</div>
              <h1 className="font-['Fugaz One'] py-9 text-6xl font-bold lg:text-7xl">
                VOTE 50
              </h1>
              <div className="flex flex-col ">
                <div className="flex items-center justify-between">
                  <p>Current Bid</p>
                  <p> {currentBid} Ξ</p>
                </div>
                <div className="flex items-center justify-between">
                  <p>Time Left</p>
                  <p> 1h 20m 30s </p>
                </div>
              </div>
              <div className="flex w-full items-center justify-around gap-2 py-10">
                <input
                  className="flex-1 rounded-2xl px-2 py-4 placeholder:text-lg placeholder:font-bold focus:border-sky-500 focus:outline-none focus:ring-1"
                  placeholder="Ξ 0.1 or more"
                  type="number"
                ></input>
                <button className="flex-2 rounded-lg bg-orange-500 px-3 py-2 text-center text-white">
                  Place Bid
                </button>
              </div>
              <div className="flex flex-col justify-between">
                <div className="flex items-center justify-between">
                  <p>vict0xr.eth</p>
                  <div className="flex gap-2">
                    <p> 0.4 Ξ</p>
                    <p>🔗</p>
                  </div>
                </div>
                <div className="my-3 h-0 w-full border border-black"></div>
                <div className="flex items-center justify-between">
                  <p>chilleeman.eth</p>
                  <div className="flex gap-2">
                    <p> 0.2 Ξ</p>
                    <p>🔗</p>
                  </div>
                </div>
                <div className="my-3 h-0 w-full border border-black"></div>
                <div className="flex items-center justify-between">
                  <p>adamstallard.eth</p>
                  <div className="flex gap-2">
                    <p> 0.1 Ξ</p>
                    <p>🔗</p>
                  </div>
                </div>
                <div className="my-3 h-0 w-full border border-black"></div>
              </div>
              <div className="w-full py-2 text-center"> View All Bids</div>
            </div>
          </main>
        </div>
      </div>
      <>
        <section>
          <div className="flex flex-col">
            <div>
              <h1>
                <p>One Noun, Every Day, Forever.</p>
              </h1>
              <p>
                <p>
                  Behold, an infinite work of art! Nouns is a community-owned
                  brand that makes a positive impact by funding ideas and
                  fostering collaboration. From collectors and technologists, to
                  non-profits and brands, Nouns is for everyone.
                </p>
              </p>
            </div>
          </div>
          <div>
            {/* <iframe
              src="https://www.youtube.com/embed/lOzCA7bZG_k"
              title="YouTube video player"
              frameBorder="0"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
              allowFullScreen
            ></iframe> */}
          </div>
        </section>
        <section>
          <div className="flex flex-col">
            {/* <iframe
              src="https://www.youtube.com/embed/oa79nN4gMPs"
              title="YouTube video player"
              frameBorder="0"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
              allowFullScreen
            ></iframe> */}
          </div>

          <div className="flex flex-col">
            <div>
              <h1>
                <p>Build With Nouns. Get Funded.</p>
              </h1>
              <p>
                <p>
                  There’s a way for everyone to get involved with Nouns. From
                  whimsical endeavors like naming a frog, to ambitious projects
                  like constructing a giant float for the Rose Parade, or even
                  crypto infrastructure like {""}. Nouns funds projects of all
                  sizes and domains.
                </p>
              </p>
            </div>
          </div>
        </section>
      </>
    </>
  );
}

export default App;
