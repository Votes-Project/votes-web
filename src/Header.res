@module external reactLogo: 'a = "./assets/react.svg"

@module external viteLogo: 'a = "/vite.svg"

module ConnectButton = {
  @react.component @module("@rainbow-me/rainbowkit")
  external make: unit => React.element = "ConnectButton"
}

module ReactIcons = {
  module LuMenu = {
    @react.component @module("react-icons/lu")
    external make: (~onClick: 'a => unit, ~size: string, ~color: string) => React.element = "LuMenu"
  }
}

@react.component
let make = () => {
  let (isOpen, setIsOpen) = React.useState(_ => false)

  let handleMenu = () => {
    setIsOpen(isOpen => !isOpen)
  }

  <header>
    <nav className="bg-primary flex w-full justify-between px-2 py-5">
      <div className="flex gap-3 ">
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo["default"]} className="logo" alt="Vite logo" />
        </a>
        <div
          className="px-3 bg-white rounded-lg flex justify-center items-center font font-semibold">
          <p> {"🦉 1000"->React.string} </p>
        </div>
      </div>
      <div className="hidden lg:flex lg:visible">
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo["default"]} className="logo react" alt="React logo" />
        </a>
        <ConnectButton />
      </div>
      <div className={`lg:hidden ${isOpen ? "border-4 border-white rounded-lg" : ""} `}>
        <ReactIcons.LuMenu color="white" size={"4rem"} onClick={_ => handleMenu()} />
      </div>
    </nav>
    <div
      className={`${isOpen
          ? "flex flex-col gap-2  w-full justify-center items-center py-5 bg-secondary "
          : "hidden"} color-active`}>
      <div className="border-primary border-2 p-2 rounded-xl"> {"AFTaf"->React.string} </div>
      <div className="border-primary border-2 p-2 rounded-xl"> {"Afaft"->React.string} </div>
      <div className="border-primary border-2 p-2 rounded-xl"> {"Afaft"->React.string} </div>
      <div className="border-primary border-2 p-2 rounded-xl"> {"Afaft"->React.string} </div>
      <ConnectButton />
    </div>
  </header>
}
