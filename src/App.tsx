import { useState } from "react";
import viteLogo from "/vite.svg";
import { make as Header } from "./Header.bs.js";

function App() {
  const [count, setCount] = useState(0);
  const [currentBid, setCurrentBid] = useState("0");
  const now = new Date();
  const todaysDate = now.toDateString();

  return (
    <>
      <div className="wrapper flex flex-col h-screen w-screen">
        <Header />
        <div className="bg-orange-300 w-full h-80 relative">
          <div className="w-full h-full flex flex-col justify-end  items-center">
            <img className="w-[50%] " src={viteLogo}></img>
          </div>
          <div>{/* <chart></chart> */}</div>
        </div>
        <main className=" bg-zinc-400 px-4">
          <div className="flex items-center pt-5">
            <div className="flex gap-2">
              <button className="bg-orange-300 rounded-full flex justify-center items-center h-8 w-8 ">
                ⬅️
              </button>
              <button className="bg-orange-300 rounded-full flex justify-center items-center h-8 w-8 ">
                ➡️
              </button>
              <p> {todaysDate}</p>{" "}
            </div>
          </div>
          <div>{/* view toggle */}</div>
          <h1 className="py-9 font-['Fugaz One'] font-bold text-5xl">
            {" "}
            VOTE 50
          </h1>
          <div className="flex flex-col ">
            <div className="flex justify-between items-center">
              <p>Current Bid</p>
              <p> {currentBid} Ξ</p>
            </div>
            <div className="flex justify-between items-center">
              <p>Time Left</p>
              <p> 1h 20m 30s </p>
            </div>
          </div>
          <div className="flex w-full items-center justify-around gap-2 py-10">
            <input
              className="py-4 px-2 flex-1 rounded-2xl focus:outline-none focus:border-sky-500 focus:ring-1 placeholder:text-lg placeholder:font-bold"
              placeholder="Ξ 0.1 or more"
              type="number"
            ></input>
            <button className="flex-2 px-3 py-2 text-white bg-orange-500 text-center rounded-lg">
              Place Bid
            </button>
          </div>
          <div className="flex flex-col justify-between">
            <div className="flex justify-between items-center">
              <p>vict0xr.eth</p>
              <div className="flex gap-2">
                <p> 0.4 Ξ</p>
                <p>🔗</p>
              </div>
            </div>
            <div className="w-full h-0 border border-black my-3"></div>
            <div className="flex justify-between items-center">
              <p>chilleeman.eth</p>
              <div className="flex gap-2">
                <p> 0.2 Ξ</p>
                <p>🔗</p>
              </div>
            </div>
            <div className="w-full h-0 border border-black my-3"></div>
            <div className="flex justify-between items-center">
              <p>adamstallard.eth</p>
              <div className="flex gap-2">
                <p> 0.1 Ξ</p>
                <p>🔗</p>
              </div>
            </div>
            <div className="w-full h-0 border border-black my-3"></div>
          </div>
          <div className="text-center w-full py-2"> View All Bids</div>
        </main>
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
            <iframe
              src="https://www.youtube.com/embed/lOzCA7bZG_k"
              title="YouTube video player"
              frameBorder="0"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
              allowFullScreen
            ></iframe>
          </div>
        </section>
        <section>
          <div className="flex flex-col">
            <iframe
              src="https://www.youtube.com/embed/oa79nN4gMPs"
              title="YouTube video player"
              frameBorder="0"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
              allowFullScreen
            ></iframe>
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
