@react.component
let make = () => {
  let keys = UseKeyPairHook.useKeyPair()
  let {setParams} = Routes.Main.Route.useQueryParams()
  let setDailyQuestion = dailyQuestion => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        ...c,
        contextId: keys->Option.map(({contextId}) => contextId),
        dailyQuestion,
      },
    )
  }
  <div className="fixed right-6 bottom-6 z-10">
    <ReactTooltip anchorSelect="#daily-question" content="Today's Question" />
    <button
      id="daily-question"
      type_="button"
      onClick={_ => setDailyQuestion(Some(0))}
      className="flex items-center justify-center text-white bg-primary-dark rounded-full w-16 h-16 md:w-20 md:h-20 hover:pg-activ  focus:ring-4 focus:ring-active focus:outline-none shadow-lg ">
      <ReactIcons.LuCalendarCheck className="w-10 h-10 md:w-12 md:h-12" />
    </button>
  </div>
}
