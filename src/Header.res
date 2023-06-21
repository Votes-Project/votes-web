@module external reactLogo: 'a = "./assets/react.svg"

@module external viteLogo: 'a = "/vite.svg"

@react.component
let make = () => {
  <header className="bg-primary flex w-full justify-between px-2 py-5">
    <div className="flex gap-3">
      <a href="https://vitejs.dev" target="_blank">
        <img src={viteLogo["default"]} className="logo" alt="Vite logo" />
      </a>
      <div className="px-3 bg-white rounded-lg flex justify-center items-center font font-semibold">
        <p> {"🦉 1000"->React.string} </p>
      </div>
    </div>
    <div>
      <a href="https://react.dev" target="_blank">
        <img src={reactLogo["default"]} className="logo react" alt="React logo" />
      </a>
    </div>
    <dropdown>
      <div> {"wow"->React.string} </div>
    </dropdown>
  </header>
}
