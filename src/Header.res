@module external reactLogo: 'a = "./assets/react.svg"

@module external viteLogo: 'a = "/vite.svg"

module ConnectButton = {
  @react.component @module("@rainbow-me/rainbowkit")
  external make: (~className: string=?) => React.element = "ConnectButton"
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

  let {queryParams} = Routes.Main.DailyQuestion.Route.useQueryParams()
  let links = {
    open ReactIcons

    [
      (
        "Daily Question",
        Routes.Main.DailyQuestion.Route.makeLinkFromQueryParams(queryParams),
        <LuCalendarCheck size="1.5rem" />,
      ),
      ("Votes", Routes.Votes.Route.makeLink(), <LuCheckCircle size="1.5rem" />),
      ("Questions", Routes.Questions.Route.makeLink(), <LuHistory size="1.5rem" />),
    ]
  }

  <header>
    <nav className="bg-secondary flex w-full justify-between px-4 py-5">
      <div className="flex gap-3 justify-center items-center ">
        <a
          href="https://vitejs.dev"
          target="_blank"
          className="relative z-2 px-2 py-0 transition-all">
          <img src={viteLogo["default"]} className="w-16 h-16  lg:w-20 lg:h-20" alt="Vite logo" />
        </a>
        <div
          className=" bg-active text-white hover:bg-white hover:text-active hover:cursor-pointer rounded-xl flex items-center font-semibold mr-4 px-3 h-10 justify-center gap-5 transition-all">
          <p className="text-2xl"> {"🦉"->React.string} </p>
          <p className="text-lg"> {"1000"->React.string} </p>
        </div>
      </div>
      <div className="hidden lg:flex lg:visible gap-4 justify-center items-center">
        {links
        ->Array.map(((name, link, icon)) => {
          <RelayRouter.Link
            key={name}
            to_={link}
            className="border border-active  hover:bg-active hover:text-white rounded-xl flex items-center font-semibold mr-4 px-3 h-10 justify-center gap-2 transition-all">
            {icon}
            {name->React.string}
          </RelayRouter.Link>
        })
        ->React.array}
        <ConnectButton />
      </div>
      <div
        className={`lg:hidden ${isOpen
            ? "border-2 border-active rounded-lg"
            : ""}  flex justify-center items-center m-1`}>
        <ReactIcons.LuMenu color="#FB8A61" size={"3rem"} onClick={_ => handleMenu()} />
      </div>
    </nav>
    <div
      className={`${isOpen
          ? "py-10 bg-active w-full flex flex-col h-96"
          : "max-h-0"} color-active transition-all justify-around items-center flex lg:max-h-0 lg:p-0 `}>
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
        <ConnectButton />
      </div>
    </div>
  </header>
}
