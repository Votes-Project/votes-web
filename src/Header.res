@module external reactLogo: 'a = "./assets/react.svg"

@module external viteLogo: 'a = "/votesy.svg"

module ConnectButton = {
  @react.component @module("@rainbow-me/rainbowkit")
  external make: (~className: string=?, ~showBalance: bool=?) => React.element = "ConnectButton"
}

type headerItem = {
  name: string,
  link: string,
  icon: ReactIcons.t,
}

@react.component
let make = () => {
  let (isOpen, setIsOpen) = React.useState(_ => false)

  let handleMenu = () => {
    setIsOpen(isOpen => !isOpen)
  }

  let {setParams} = Routes.Main.Route.useQueryParams()

  let setDailyQuestion = dailyQuestion => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        dailyQuestion,
      },
    )
  }

  let links = {
    open ReactIcons

    [
      ("Votes", Routes.Main.Votes.Route.makeLink(), <LuCheckCircle size="1.5rem" />),
      ("Questions", Routes.Main.Questions.Route.makeLink(), <LuHistory size="1.5rem" />),
    ]
  }

  <header className="flex flex-col justify-center items-center ">
    <nav className=" bg-secondary max-w-7xl noise flex w-full justify-between px-4  pt-2">
      <div className="flex gap-3 justify-center items-center ">
        <RelayRouter.Link
          to_={Routes.Main.Route.makeLink()} className="relative z-2 px-2 py-0 transition-all z-10">
          <img src={viteLogo["default"]} className="w-24 h-24  " alt="Vite logo" />
        </RelayRouter.Link>
        <div
          className=" bg-active text-white hover:bg-white hover:text-active hover:cursor-pointer rounded-xl flex items-center font-semibold mr-4 px-3 h-10 justify-center gap-5 transition-all">
          <p className="text-2xl"> {"🦉"->React.string} </p>
          <p className="text-lg"> {"1000"->React.string} </p>
        </div>
      </div>
      <div className="hidden lg:flex lg:visible gap-4 justify-center items-center">
        <button
          onClick={_ => setDailyQuestion(Some(""))}
          className="border-[1.5px] border-primary cursor-pointer  hover:bg-active hover:text-white rounded-xl flex items-center font-semibold mr-4 px-3 h-10 justify-center gap-2 transition-all">
          <ReactIcons.LuCalendarCheck size="1.5rem" />
          {"Daily Question"->React.string}
        </button>
        {links
        ->Array.map(((name, link, icon)) => {
          <RelayRouter.Link
            key={name}
            to_={link}
            className="border-[1.5px] border-primary  hover:bg-active hover:text-white rounded-xl flex items-center font-semibold mr-4 px-3 h-10 justify-center gap-2 transition-all">
            {icon}
            {name->React.string}
          </RelayRouter.Link>
        })
        ->React.array}
        <ConnectButton showBalance=false />
      </div>
      <button
        className={`lg:hidden ${isOpen
            ? "border-2 border-active rounded-lg"
            : ""}  flex justify-center items-center m-1 h-11 self-center`}>
        <ReactIcons.LuMenu color="#FB8A61" size={"2.5rem"} onClick={_ => handleMenu()} />
      </button>
    </nav>
    <div
      className={`${isOpen
          ? "py-10 bg-active w-full flex flex-col h-96"
          : "max-h-0"} color-active transition-all justify-around items-center flex lg:max-h-0 lg:p-0 `}>
      <button
        onClick={_ => setDailyQuestion(Some(""))}
        className={`lg:hidden justify-center items-center w-[262px] flex px-2 py-3 border border-primary rounded-xl font-bold text-white text-xl gap-2 transition-all ${isOpen
            ? ""
            : "hidden"}`}>
        <ReactIcons.LuCalendarCheck size="1.5rem" />
        {"Daily Question"->React.string}
      </button>
      {links
      ->Array.map(((name, link, icon)) => {
        <RelayRouter.Link
          key={name}
          to_={link}
          className={`lg:hidden justify-center items-center w-[262px] flex px-2 py-3 border border-primary rounded-xl font-bold text-white text-xl gap-2 transition-all ${isOpen
              ? ""
              : "hidden"}`}>
          {icon}
          {name->React.string}
        </RelayRouter.Link>
      })
      ->React.array}
      <div className={`${isOpen ? "" : "hidden"} lg:hidden`}>
        <ConnectButton showBalance=false />
      </div>
    </div>
  </header>
}
