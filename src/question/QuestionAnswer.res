module QuestionFragment = %relay(`
  fragment QuestionAnswer_question on Question {
    title
    asker
    day
    ...OptionsList_question
    ...QuestionTitle_question
    ...AnswersList_question
  }`)

module AnswerFragment = %relay(`
  fragment QuestionAnswer_answer on Answer {
    option
    ...AnswersList_answer
  }`)

module Query = %relay(`
  query QuestionAnswerQuery($condition: AnswerCondition) {
    ...AnswersList_query @arguments(condition: $condition)
  }
`)

@react.component
let make = (~question, ~answer) => {
  let question = QuestionFragment.use(question)
  let answer = AnswerFragment.useOpt(answer)
  let query = Query.use(
    ~variables={
      condition: switch question.day {
      | Some(day) => {day: day->BigInt.toInt}
      | None => {day: -1}
      },
    },
  )

  let {setHeroComponent} = React.useContext(HeroComponentContext.context)
  let votesy = React.useContext(VotesySpeakContext.context)

  let answerRef = React.useCallback0(element => {
    switch element->Nullable.toOption {
    | Some(element) =>
      element->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: End})
    | None => ()
    }
  })

  let {setParams} = Routes.Main.Route.useQueryParams()
  let handleLinkBrightId = _ => {
    setParams(
      ~removeNotControlledParams=false,
      ~navigationMode_=Push,
      ~shallow=false,
      ~setter=c => {
        {
          ...c,
          linkBrightID: Some(0),
        }
      },
    )
  }

  let questionTextSize =
    question.title
    ->Option.getWithDefault("")
    ->String.length
    ->QuestionTitle.size

  React.useEffect0(() => {
    setHeroComponent(_ =>
      <div
        className="flex flex-col items-center w-full p-4 lg:h-[420px] lg:min-h-[420px] min-h-[40vh]"
        ref={ReactDOM.Ref.callbackDomRef(answerRef)}>
        <div
          className="flex-1 flex items-end self-start text-xl font-semibold text-default-darker text-center ">
          <ShortAddress address=Some(question.asker) avatar=true />
        </div>
        <QuestionTitle
          question={question.fragmentRefs}
          className={`align-stretch font-bold flex-2 flex justify-center items-center [text-wrap:balance] text-center text-default-darker px-4  ${questionTextSize}`}
        />
        <div className="w-full flex-col flex-1 px-4">
          <div className="w-full flex flex-row justify-between items-center">
            <p className="text-xl font-semibold text-default-darker text-center">
              {"🔥 Answer Streak"->React.string}
            </p>
            <p className="text-xl font-semibold text-default-darker text-center">
              {"1"->React.string}
            </p>
          </div>
        </div>
      </div>
    )
    if answer->Option.isSome {
      votesy.setPosition(_ => Fixed)
      votesy.setContent(_ =>
        <div
          className="h-full  p-2 rounded-lg flex flex-col items-center font-semibold overflow-hidden transition-all">
          {"Good Answer! Link a BrightID to collect your reward!"->React.string}
          <button
            onClick={handleLinkBrightId}
            className="bg-active hover:scale-105 transition-all text-white font-bold py-2 px-4 rounded mt-4">
            {"Link BrightID"->React.string}
          </button>
        </div>->Some
      )
    }

    None
  })
  switch answer {
  | Some(answer) =>
    <AnswersList
      query={query.fragmentRefs} question={question.fragmentRefs} answer={answer.fragmentRefs}
    />
  | None => <OptionsList question={question.fragmentRefs} />
  }
}
