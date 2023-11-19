module Alert = {
  @react.component
  let make = () => {
    <div
      className="absolute top-[-2px] right-[-2px] font-fugaz flex justify-center items-center w-4 h-4 rounded-full bg-active text-white text-xs animate-pulse">
      {"!"->React.string}
    </div>
  }
}

@react.component @relay.deferredComponent
let make = () => {
  <div className="flex flex-col justify-around h-full">
    <header className="flex justify-between items-center p-6 mx-4 border-b border-gray-200">
      <h1 className="text-2xl lg:text-3xl font-semibold text-default-darker">
        {"Your Voter Stats"->React.string}
      </h1>
    </header>
    <div className=" w-full h-full flex flex-col justify-between items-center p-8">
      <div className="w-full flex flex-col justify-between items-center text-xl font-fugaz">
        <div className="flex flex-row justify-between items-center w-full">
          <p> {"Voter ID:"->React.string} </p>
          <p> {"123456789"->React.string} </p>
        </div>
        <div className="flex flex-row justify-between items-center w-full">
          <p> {"BrightID:"->React.string} </p>
          <p> {"Verified"->React.string} </p>
        </div>
      </div>
      <div className="w-full flex justify-between items-center text-xl font-fugaz">
        //Write Points Component
        <p> {"Points"->React.string} </p>
        <p> {"0"->React.string} </p>
      </div>
      <div className="w-full flex justify-between items-center text-xl font-fugaz">
        <p> {"Streak"->React.string} </p>
        <p> {"0"->React.string} </p>
      </div>
    </div>
  </div>
}
