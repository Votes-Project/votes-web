@react.component
let make = () => {
  let {setHeroComponent} = React.useContext(HeroComponentContext.context)
  React.useEffect1(() => {
    setHeroComponent(_ =>
      <div className="p-4 w-full flex-1 flex justify-center items-center backdrop-blur-[2px] ">
        <div
          className="flex flex-col items-start w-full p-4 border-2 pb-2 bg-black/50 animate-pulse flex-1 relative rounded-xl transition-all duration-200 ease-linear">
          <div
            id="create-vote-title"
            className="w-[90vw] lg:w-auto min-h-[300px] max-w-md lg:p-4 p-2 border-none focus:ring-0 break-words bg-transparent cursor-pointer text-wrap focus:cursor-text focus:text-left text-xl lg:text-2xl transition-all duration-300 ease-linear "
          />
        </div>
      </div>
    )
    None
  }, [setHeroComponent])
  <div className="flex justify-center items-center h-full">
    <div className=" p-4 flex items-center justify-center w-full">
      <div
        className="relative lg:p-4 w-full h-full  flex flex-col justify-around items-center lg:border-2 animate-pulse lg:border-black/50 rounded-xl ">
        <div className="h-full w-full rounded-xl flex justify-start flex-col z-10 pb-4 gap-4">
          <div className="flex flex-col lg:flex-row ">
            <h2 className="text-xl lg:text-2xl text-black opacity-60 ">
              {"Add Options"->React.string}
            </h2>
            <ol className="flex flex-col justify-start items-start flex-1 ">
              {["", ""]
              ->Array.mapWithIndex((_, index) => {
                <li
                  key={Int.toString(index)}
                  className="relative pr-10 my-3 w-full flex items-center border-2  bg-black/50 text-left background-transparent animate-pulse backdrop-blur-md transition-all duration-200 ease-linear rounded-xl">
                  <div
                    className="w-9 flex items-center justify-center relative font-bold text-2xl h-full text-default-dark lg:text-primary-dark bg-default lg:bg-primary px-3 rounded-l-lg border-default-dark lg:border-primary border-r-2 overflow-hidden "
                  />
                  <div className=" bg-black/50 animate-pulse py-2 " />
                </li>
              })
              ->React.array}
            </ol>
          </div>
        </div>
      </div>
    </div>
  </div>
}
