module QuestionFragment = %relay(`
fragment AnswersList_question on Question {
  options
}
`)

module UserAnswerFragment = %relay(`
fragment AnswersList_answer on Answer {
  option
}
`)

module QueryFragment = %relay(`
  fragment AnswersList_query on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 10 }
    after: { type: "Cursor" }
    condition: { type: "AnswerCondition" }
  )
  @refetchable(queryName: "AnswersListQuery") {
    answers(first: $first, after: $after, condition: $condition)
      @connection(key: "AnswersList_answers") {
      totalCount
      edges {
        node {
          option
          user {
            verified
          }
        }
      }
    }
  }
`)

exception NoAnswer

@react.component
let make = (~query, ~question, ~answer) => {
  let questionOptions = QuestionFragment.use(question).options->Option.getExn
  let userAnswer = UserAnswerFragment.use(answer)
  let {answers: answersByDay} = QueryFragment.use(query)

  let (answersByOption, noAnswers) =
    answersByDay
    ->QueryFragment.getConnectionNodes
    ->Array.reduce(([], []), ((groupedAnswers, noAnswers), answer) =>
      switch answer.option {
      | Some(option) =>
        let groupedAnswers = groupedAnswers->Array.mapWithIndex((curr, index) =>
          switch index {
          | i if i == option =>
            groupedAnswers
            ->Array.get(option)
            ->Option.getWithDefault([])
            ->Array.concat([answer])
          | _ => curr
          }
        )
        (groupedAnswers, noAnswers)

      | None => (groupedAnswers, noAnswers->Array.concat([answer]))
      }
    )

  open FramerMotion
  answersByOption
  ->Array.mapWithIndex((answers, index) => {
    let option = questionOptions->Array.get(index)->Option.flatMap(({?option}) => option)
    let answerPercentage = switch answersByDay {
    | Some({totalCount: 0}) | None => raise(NoAnswer)
    | Some({totalCount}) => answers->Array.length->float /. totalCount->float
    }
    switch (option, userAnswer.option) {
    | (Some(option), Some(answer)) if answer == index =>
      <li
        className={` border-y-4 lg:border-4 border-default-darker lg:border-active focus:outline-none focus:ring-0 relative
  font-semibold text-sm my-3 w-full flex items-center text-left backdrop-blur-md transition-all duration-200 ease-linear
  lg:rounded-xl text-default-darker shadow-lg bg-default-light hover:lg:scale-105 focus:lg:scale-105`}
        key={index->Int.toString}>
        <div
          className="z-10 pointer-events-none w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-darker lg:text-active px-5 rounded-l-lg ">
          {(index + 65)->String.fromCharCode->React.string}
        </div>
        <div
          className={`focus:outline-none z-10 focus:ring-0 w-full flex flex-row items-center lg:my-2 first:mb-2 py-2 px-2
    min-h-[80px] overflow-hidden transition-all`}
          key={index->Int.toString}>
          <p className=" font-bold pointer-events-none"> {option->React.string} </p>
        </div>
        <p className="z-10 pointer-events-none px-4 text-xl font-bold">
          {(answerPercentage->Float.toString ++ "%")->React.string}
        </p>
        <FramerMotion.Div
          className="absolute h-full bg-default lg:bg-secondary lg:rounded-xl"
          initial=Initial({width: "0"})
          animate={Animate({width: answerPercentage->Float.toString ++ "%"})}
        />
      </li>
    | (Some(option), _) =>
      <li
        className={` opacity-80 focus:outline-none focus:ring-0 relative font-semibold text-sm my-3 w-full flex items-center
  text-left backdrop-blur-md transition-all duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg
  bg-default-light hover:lg:scale-105 focus:lg:scale-105`}
        key={index->Int.toString}>
        <div
          className="z-10 pointer-events-none w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-dark lg:text-primary-dark px-5 rounded-l-lg ">
          {(index + 65)->String.fromCharCode->React.string}
        </div>
        <div
          className={` z-10 focus:outline-none focus:ring-0 w-full flex flex-row items-center lg:my-2 first:mb-2 py-2 px-2
    min-h-[80px] overflow-hidden transition-all`}
          key={index->Int.toString}>
          <p className=" pointer-events-none"> {option->React.string} </p>
        </div>
        <div className="px-4 text-xl font-bold">
          <p className="z-10 pointer-events-none">
            {(answerPercentage->Float.toString ++ "%")->React.string}
          </p>
        </div>
        <FramerMotion.Div
          className=" absolute h-full bg-default lg:bg-secondary lg:rounded-xl"
          initial=Initial({width: "0"})
          animate={Animate({width: answerPercentage->Float.toString ++ "%"})}
        />
      </li>
    | _ =>
      <li
        className={` opacity-80 focus:outline-none focus:ring-0 relative font-semibold text-sm my-3 w-full flex items-center
  text-left backdrop-blur-md transition-all duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg
  bg-default-light hover:lg:scale-105 focus:lg:scale-105`}
        key={index->Int.toString}>
        <div
          className="z-10 pointer-events-none w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-dark lg:text-primary-dark px-5 rounded-l-lg ">
          {(index + 65)->String.fromCharCode->React.string}
        </div>
        <div
          className={` z-10 focus:outline-none focus:ring-0 w-full flex flex-row items-center lg:my-2 first:mb-2 py-2 px-2
    min-h-[80px] overflow-hidden transition-all`}
          key={index->Int.toString}>
          <p className=" pointer-events-none"> {"Error"->React.string} </p>
        </div>
        <div className="px-4 text-xl font-bold">
          <p className="z-10 pointer-events-none">
            {(answerPercentage->Float.toString ++ "%")->React.string}
          </p>
        </div>
        <FramerMotion.Div
          className=" absolute h-full bg-default lg:bg-secondary lg:rounded-xl"
          initial=Initial({width: "0"})
          animate={Animate({width: answerPercentage->Float.toString ++ "%"})}
        />
      </li>
    }
  })
  ->Array.concat([
    {
      let answerPercentage = switch answersByDay {
      | Some({totalCount: 0}) | None => raise(NoAnswer)
      | Some({totalCount}) => noAnswers->Array.length->float /. totalCount->float
      }
      let index = questionOptions->Array.length
      switch userAnswer.option {
      | None =>
        <li
          className={` border-y-4 lg:border-4 border-default-darker lg:border-active focus:outline-none focus:ring-0 relative
  font-semibold text-sm my-3 w-full flex items-center text-left backdrop-blur-md transition-all duration-200 ease-linear
  lg:rounded-xl text-default-darker shadow-lg bg-default-light hover:lg:scale-105 focus:lg:scale-105`}
          key={index->Int.toString}>
          <div
            className="z-10 pointer-events-none w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-darker lg:text-active px-5 rounded-l-lg ">
            {(index + 65)->String.fromCharCode->React.string}
          </div>
          <div
            className={`focus:outline-none z-10 focus:ring-0 w-full flex flex-row items-center lg:my-2 first:mb-2 py-2 px-2
    min-h-[80px] overflow-hidden transition-all`}
            key={index->Int.toString}>
            <p className=" font-bold pointer-events-none"> {"Other"->React.string} </p>
          </div>
          <p className="z-10 pointer-events-none px-4 text-xl font-bold">
            {(answerPercentage->Float.toString ++ "%")->React.string}
          </p>
          <FramerMotion.Div
            className="absolute h-full bg-default lg:bg-secondary lg:rounded-xl"
            initial=Initial({width: "0"})
            animate={Animate({width: answerPercentage->Float.toString ++ "%"})}
          />
        </li>
      | _ =>
        <li
          className={` opacity-80 focus:outline-none focus:ring-0 relative font-semibold text-sm my-3 w-full flex items-center
  text-left backdrop-blur-md transition-all duration-200 ease-linear lg:rounded-xl text-default-darker shadow-lg
  bg-default-light hover:lg:scale-105 focus:lg:scale-105`}
          key={index->Int.toString}>
          <div
            className="z-10 pointer-events-none w-9 flex flex-1 items-center justify-center relative font-bold text-3xl h-full text-default-dark lg:text-primary-dark px-5 rounded-l-lg ">
            {(index + 65)->String.fromCharCode->React.string}
          </div>
          <div
            className={` z-10 focus:outline-none focus:ring-0 w-full flex flex-row items-center lg:my-2 first:mb-2 py-2 px-2
    min-h-[80px] overflow-hidden transition-all`}
            key={index->Int.toString}>
            <p className=" pointer-events-none"> {"Other"->React.string} </p>
          </div>
          <div className="px-4 text-xl font-bold">
            <p className="z-10 pointer-events-none">
              {(answerPercentage->Float.toString ++ "%")->React.string}
            </p>
          </div>
          <FramerMotion.Div
            className=" absolute h-full bg-default lg:bg-secondary lg:rounded-xl"
            initial=Initial({width: "0"})
            animate={Animate({width: answerPercentage->Float.toString ++ "%"})}
          />
        </li>
      }
    },
  ])
  ->React.array
}
