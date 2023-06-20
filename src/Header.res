@module external reactLogo: 'a = "./assets/react.svg"

@module external viteLogo: 'a = "/vite.svg"

@react.component
let make = () => {
  <header className="bg-orange-300 flex w-full justify-between px-2 py-5">
    <div>
      <a href="https://vitejs.dev" target="_blank">
        <img src={viteLogo["default"]} className="logo" alt="Vite logo" />
      </a>
    </div>
    <div className="px-3 bg-zinc-400"> {"1000"->React.string} </div>
    <div>
      <a href="https://react.dev" target="_blank">
        <img src={reactLogo["default"]} className="logo react" alt="React logo" />
      </a>
    </div>
  </header>
}
