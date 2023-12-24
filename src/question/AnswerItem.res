@react.component
let make = (~option, ~answer, ~index) => {
  open FramerMotion
  let numAnswerPercentage = Math.ceil(Math.random() *. 100.)

  switch answer {
  | Some(answer) if answer == index =>
    <li
      className={` border-y-4 lg:border-4 border-default-darker lg:border-active focus:outline-none focus:ring-0 relative
  font-semibold text-sm my-3 w-full flex items-center text-left backdrop-blur-md transition-all duration-200 ease-linear
  lg:rounded-xl text-default-darker shadow-lg bg-default-light hover:lg:scale-105 focus:lg:scale-105`}
      key={index->Int.toString}>
      <div
        className="z-10 pointer-events-none w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-darker lg:text-active px-5 rounded-l-lg ">
        {(index + 65)->String.fromCharCode->React.string}
      </div>
      <div
        className={`focus:outline-none z-10 focus:ring-0 w-full flex flex-row items-center lg:my-2 first:mb-2 py-2 px-2
    min-h-[80px] overflow-hidden transition-all`}
        key={index->Int.toString}>
        <p className=" font-bold pointer-events-none"> {option->React.string} </p>
      </div>
      <p className="z-10 pointer-events-none px-4 text-xl font-bold">
        {(numAnswerPercentage->Float.toString ++ "%")->React.string}
      </p>
      <FramerMotion.Div
        className="absolute h-full bg-default lg:bg-secondary lg:rounded-xl"
        initial=Initial({width: "0"})
        animate={Animate({width: numAnswerPercentage->Float.toString ++ "%"})}
      />
    </li>
  | _ =>
    <li
      className={` opacity-80 focus:outline-none focus:ring-0 relative font-semibold text-sm my-3 w-full flex items-center
  text-left backdrop-blur-md transition-all duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg
  bg-default-light hover:lg:scale-105 focus:lg:scale-105`}
      key={index->Int.toString}>
      <div
        className="z-10 pointer-events-none w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-dark lg:text-primary-dark px-5 rounded-l-lg ">
        {(index + 65)->String.fromCharCode->React.string}
      </div>
      <div
        className={` z-10 focus:outline-none focus:ring-0 w-full flex flex-row items-center lg:my-2 first:mb-2 py-2 px-2
    min-h-[80px] overflow-hidden transition-all`}
        key={index->Int.toString}>
        <p className=" pointer-events-none"> {option->React.string} </p>
      </div>
      <div className="px-4 text-xl font-bold">
        <p className="z-10 pointer-events-none">
          {(numAnswerPercentage->Float.toString ++ "%")->React.string}
        </p>
      </div>
      <FramerMotion.Div
        className=" absolute h-full bg-default lg:bg-secondary lg:rounded-xl"
        initial=Initial({width: "0"})
        animate={Animate({width: numAnswerPercentage->Float.toString ++ "%"})}
      />
    </li>
  }
}
