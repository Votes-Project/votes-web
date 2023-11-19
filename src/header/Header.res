@module external reactLogo: 'a = "/assets/react.svg"

@module external viteLogo: 'a = "/votesy.svg"

type headerItem = {
  name: string,
  link: string,
  icon: ReactIcons.t,
}

module Fragment = %relay(`
  fragment HeaderFragment on Query
  @argumentDefinitions(context: { type: "String!", defaultValue: "Votes" }) {
    verifications(context: $context) {
      ...VoterCount
    }
    randomQuestion {
      id
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
let make = (~verifications) => {
  let {verifications, randomQuestion} = Fragment.use(verifications)
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

  <header className=" flex flex-col justify-center items-center mb-[-8px] w-full">
    <nav className=" max-w-7xl flex w-full justify-between px-4 pt-2 flex-1">
      <div className="flex gap-3 justify-center items-center ">
        <div
          // to_={Routes.Main.Question.Current.Route.makeLink(
          //   ~id=randomQuestion->Option.map(q => q.id)->Option.getWithDefault(""),
          // )}
          className="relative z-2 px-2 py-0 transition-all z-2"
          onClick={_ => votesy.setShow(_ => true)}>
          <div className="relative w-24 h-24">
            <div className="fixed z-50">
              <img src={viteLogo["default"]} className="w-24 h-24  " alt="Vite logo" />
              {switch votesy.show {
              | true => <VotesySpeak />
              | false => <> </>
              }}
            </div>
          </div>
        </div>
        <div
          className="   bg-secondary hover:bg-secondary  hover:cursor-pointer rounded-xl flex items-center font-semibold mr-4 px-2 h-10 justify-center transition-all">
          <p className="text-lg text-active  ml-1 mr-3"> {"Voters"->React.string} </p>
          <div className="flex items-center justify-around text-default-darker">
            <ReactIcons.LuVote size="1.5rem" />
            <ErrorBoundary fallback={_ => "N/A"->React.string}>
              <React.Suspense fallback={<> </>}>
                <VoterCount verifications={verifications.fragmentRefs} />
              </React.Suspense>
            </ErrorBoundary>
          </div>
        </div>
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
    <div
      ref={ReactDOM.Ref.domRef(accordionRef)}
      className={`${isOpen
          ? "py-10 bg-active w-full flex flex-col h-96 m-[-8px]"
          : "max-h-0"} color-active transition-all justify-around items-center flex lg:max-h-0 lg:p-0 `}>
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
  </header>
}
