@module external votesyLogo: 'a = "/votesy.svg"

type headerItem = {
  name: string,
  link: string,
  icon: ReactIcons.t,
}

module Fragment = %relay(`
  fragment HeaderFragment on Query {
    users {
      ...HeaderStats_users
    }
  }
`)

let links = {
  open ReactIcons

  [
    ("Raffles", Routes.Main.Raffles.Route.makeLink(), <LuAward size="1.5rem" />),
    ("Votes", Routes.Main.Votes.Route.makeLink(), <LuCheckCircle size="1.5rem" />),
    ("Questions", Routes.Main.Questions.Route.makeLink(), <LuHistory size="1.5rem" />),
  ]
}

@react.component
let make = (~users) => {
  let {users} = Fragment.use(users)
  let (isOpen, setIsOpen) = React.useState(_ => false)
  let accordionRef = React.useRef(Nullable.null)
  let hamburgerRef = React.useRef(Nullable.null)
  let isClickOutside = OutsideClickHook.use(accordionRef)
  let isClickOutsideHamburger = OutsideClickHook.use(hamburgerRef)
  let votesy = React.useContext(VotesySpeakContext.context)

  let handleMenu = _ => {
    setIsOpen(isOpen => !isOpen)
  }

  React.useEffect2(() => {
    if isClickOutside && isClickOutsideHamburger {
      setIsOpen(_ => false)
    }
    None
  }, (isClickOutside, isClickOutsideHamburger))
  <>
    <header className=" flex flex-row justify-center items-center z-50 h-24 px-2 pt-2 mb-[-8px]">
      <div className="w-24 h-24 pb-0 relative ">
        <div
          className="z-50 top-2 left-10 z-2 transition-all"
          onClick={_ => votesy.setShow(_ => true)}>
          <div className=" w-24 h-24">
            <img src={votesyLogo["default"]} className="w-24 h-24  " alt="Votesy The Owl" />
          </div>
        </div>
      </div>
      <nav className="max-w-7xl flex w-full justify-between px-4 pt-2 flex-1">
        <div className="flex gap-3 justify-center items-center ">
          <HeaderStats users={users->Option.map(users => users.fragmentRefs)} />
        </div>
        <div className="hidden lg:flex lg:visible gap-4 justify-center items-center">
          {links
          ->Array.map(((name, link, icon)) => {
            <RelayRouter.Link
              key={name}
              to_={link}
              preloadData=NoPreloading
              className="  bg-secondary hover:bg-primary-dark hover:text-white rounded-xl flex items-center font-semibold mr-4 px-3 h-10 justify-center gap-2 transition-all">
              {icon}
              {name->React.string}
            </RelayRouter.Link>
          })
          ->React.array}
          <RainbowKit.ConnectButton showBalance=false chainStatus=RainbowKit.ConnectButton.Icon />
        </div>
        <button
          ref={ReactDOM.Ref.domRef(hamburgerRef)}
          className={`lg:hidden ${isOpen
              ? "border-2 border-active rounded-lg"
              : ""}  flex justify-center items-center m-1 h-11 self-center`}>
          <ReactIcons.LuMenu color="#FB8A61" size={"2.5rem"} onClick={_ => handleMenu()} />
        </button>
      </nav>
    </header>
    <div
      ref={ReactDOM.Ref.domRef(accordionRef)}
      className={`${isOpen
          ? "py-10 bg-active w-full flex flex-col h-96 "
          : "max-h-0"} top-24 color-active transition-all justify-around items-center flex lg:max-h-0 lg:p-0 `}>
      {links
      ->Array.map(((name, link, icon)) => {
        <RelayRouter.Link
          key={name}
          to_={link}
          onClick=handleMenu
          preloadData={NoPreloading}
          className={`hover:bg-secondary hover:text-active lg:hidden justify-center items-center w-[262px] flex px-2 py-3 border border-primary rounded-xl font-bold text-white text-xl gap-2 transition-all ${isOpen
              ? ""
              : "hidden"}`}>
          {icon}
          {name->React.string}
        </RelayRouter.Link>
      })
      ->React.array}
      <div className={`${isOpen ? "" : "hidden"} lg:hidden`}>
        <RainbowKit.ConnectButton showBalance=false />
      </div>
    </div>
    <VotesySpeak />
  </>
}
