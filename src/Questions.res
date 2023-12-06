type pastQuestion = {
  id: string,
  title: string,
  day: Date.t,
}
type seedQuestion = {
  id: string,
  title: string,
}

type question =
  | Question(RescriptRelay.fragmentRefs<[#Questions_item]>)
  | SeedQuestion(seedQuestion)
  | PastQuestion(pastQuestion)

let pastQuestions = [
  PastQuestion({
    id: "1",
    title: "Past Question stand in",
    day: Date.fromTime(1701343236000.),
  }),
  PastQuestion({
    id: "2",
    title: "Past Question stand in",
    day: Date.fromTime(1701343236000. +. Helpers.Date.dayInMilliseconds),
  }),
  PastQuestion({
    id: "3",
    title: "Past Question stand in",
    day: Date.fromTime(1701343236000. +. Helpers.Date.dayInMilliseconds *. 2.),
  }),
  PastQuestion({
    id: "4",
    title: "Past Question stand in",
    day: Date.fromTime(1701343236000. +. Helpers.Date.dayInMilliseconds *. 3.),
  }),
  PastQuestion({
    id: "5",
    title: "Past Question stand in",
    day: Date.fromTime(1701343236000. +. Helpers.Date.dayInMilliseconds *. 4.),
  }),
  PastQuestion({
    id: "6",
    title: "Past Question stand in",
    day: Date.fromTime(1701343236000. +. Helpers.Date.dayInMilliseconds *. 5.),
  }),
]

let seedQuestions = [
  SeedQuestion({
    id: "a",
    title: "Seed Question stand in.",
  }),
  SeedQuestion({
    id: "b",
    title: "Seed Question stand in.",
  }),
  SeedQuestion({
    id: "c",
    title: "Seed Question stand in.",
  }),
  SeedQuestion({
    id: "d",
    title: "Seed Question stand in.",
  }),
]

module QuestionItem = {
  module Fragment = %relay(`
  fragment Questions_item on Question {
    id
    title
    tokenId
    asker
  }
`)

  @react.component
  let make = (~question) => {
    let question = Fragment.use(question)
    <div className="flex flex-col justify-center items-center">
      <div className="self-end py-2">
        <ShortAddress address=Some(question.asker) />
      </div>
      <div
        className="flex flex-col gap-2 flex-1 whitespace-pre-wrap [text-wrap:pretty] lg:bg-secondary lg:shadow-lg p-2 rounded-lg self-start mr-auto">
        {question.title->React.string}
      </div>
    </div>
  }
}

module SeedQuestionItem = {
  @react.component
  let make = (~question) => {
    <div className="flex flex-col justify-center items-center">
      <div
        className=" flex-1 whitespace-pre-wrap [text-wrap:pretty]  lg:bg-secondary lg:shadow-lg p-2 rounded-lg self-start">
        {question.title->React.string}
      </div>
    </div>
  }
}

module PastQuestionItem = {
  @react.component
  let make = (~question: pastQuestion) => {
    <div className="flex flex-col justify-center items-center">
      <div
        className=" flex-1 whitespace-pre-wrap [text-wrap:pretty]  lg:bg-secondary opacity-50 lg:shadow-lg p-2 rounded-lg self-start">
        {question.title->React.string}
      </div>
    </div>
  }
}

module Item = {
  @react.component
  let make = (~question, ~index) => {
    let {setParams} = Routes.Main.Questions.Route.useQueryParams()
    let ref = React.useRef(Nullable.null)
    let today = Date.now()->Date.fromTime

    let isToday = switch question {
    | PastQuestion({day}) => day->Date.getTime == today->Date.getTime
    | Question(_) | SeedQuestion(_) =>
      (Date.now() +. Helpers.Date.dayInMilliseconds *. float(index - pastQuestions->Array.length))
      ->Date.fromTime
      ->Date.getTime == today->Date.getTime
    }

    let day = switch question {
    | PastQuestion({day}) =>
      day->Date.toLocaleStringWithLocaleAndOptions("en-us", {day: #"2-digit"})
    | Question(_) | SeedQuestion(_) | _ =>
      (Date.now() +. Helpers.Date.dayInMilliseconds *. float(index - pastQuestions->Array.length))
      ->Date.fromTime
      ->Date.toLocaleStringWithLocaleAndOptions("en-us", {day: #"2-digit"})
    }

    let weekday = switch question {
    | PastQuestion({day}) =>
      day->Date.toLocaleStringWithLocaleAndOptions("en-us", {weekday: #short})
    | Question(_) | SeedQuestion(_) =>
      (Date.now() +. Helpers.Date.dayInMilliseconds *. float(index - pastQuestions->Array.length))
      ->Date.fromTime
      ->Date.toLocaleStringWithLocaleAndOptions("en-us", {weekday: #short})
    }

    let handleQuestionSelect = _ => {
      setParams(~removeNotControlledParams=false, ~navigationMode_=Replace, ~setter=c => {
        ...c,
        day: switch question {
        | Question(_) | SeedQuestion(_) =>
          (Date.now() +.
          Helpers.Date.dayInMilliseconds *. float(index - pastQuestions->Array.length))
          ->Date.fromTime
          ->Some

        | PastQuestion({day}) => day->Some
        },
      })
    }

    <button
      className="w-[90vw] max-w-[90vw] min-w-[90vw] h-fit  mx-1 p-2 flex snap-start lg:mx-1 lg:p-2 lg:min-w-0 lg:w-full lg:flex lg:flex-col lg:justify-center lg:items-center"
      onClick=handleQuestionSelect
      ref={ReactDOM.Ref.domRef(ref)}>
      <div
        className="flex lg:flex-1 flex-row-reverse lg:flex-row gap-2 justify-end lg:w-full items-stretch  lg:mr-auto font-semibold  ">
        <FramerMotion.Div className="flex flex-col py-2">
          {switch question {
          | Question(question) => <QuestionItem question />
          | SeedQuestion(question) => <SeedQuestionItem question />
          | PastQuestion(question) => <PastQuestionItem question />
          }}
        </FramerMotion.Div>
        <div
          className="flex lg:flex-col items-start lg:items-center lg:min-w-[4rem]  min-w-[2rem] lg:min-h-0">
          <div>
            <div
              className="select-none text-xs font-fugaz text-center lg:self-center rounded-full  text-default-darker">
              {weekday->React.string}
            </div>
            {isToday
              ? <div
                  className="select-none text-xl font-fugaz  bg-default-darker text-default-light lg:bg-active rounded-full p-2 ">
                  {day->React.string}
                </div>
              : <div className="select-none text-xl font-fugaz text-default-darker">
                  {day->React.string}
                </div>}
          </div>
        </div>
      </div>
    </button>
  }
}

module List = {
  module Fragment = %relay(`
  fragment Questions_list on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 100 }
    after: { type: "String" }
    last: { type: "Int" }
    orderDirection: { type: "OrderDirection", defaultValue: desc }
  ) {
    questions(
      first: $first
      after: $after
      last: $last
      orderDirection: $orderDirection
    ) @connection(key: "Questions_questions") {
      edges {
        node {
          id
          ...Questions_item
        }
      }
    }
  }
`)

  @react.component
  let make = (~questions) => {
    let {queryParams} = Routes.Main.Questions.Route.useQueryParams()
    let {questions} = Fragment.use(questions)
    let (height, setHeight) = React.useState(_ => None)
    let (width, setWidth) = React.useState(_ => None)

    let windowWidth = Window.Width.Inner.use()

    let ref = React.useRef(Nullable.null)
    let questionsRef = React.useRef(Nullable.null)
    let currentQuestionRef = React.useRef(Nullable.null)

    React.useEffect6(() => {
      switch (ref.current->Nullable.toOption, questionsRef.current->Nullable.toOption) {
      | (Some(current), Some(questions)) =>
        switch windowWidth {
        | LG(_) | XL(_) | XXL(_) =>
          open Element
          let height = questions->Offset.height +. current->Offset.height *. 2.
          setHeight(_ => Some(Float.toString(height) ++ "px"))
          setWidth(_ => None)
        | XS(_) | SM(_) | MD(_) =>
          open Element
          let width = questions->Offset.width +. current->Offset.width *. 2.

          setWidth(_ => Some(width->Float.toString ++ "px"))
          setHeight(_ => None)
        }
      | _ => ()
      }
      None
    }, (
      ref.current,
      questionsRef.current,
      currentQuestionRef.current,
      windowWidth,
      Window.innerWidth(window),
      queryParams,
    ))

    React.useEffect6(() => {
      open Element
      switch (ref.current->Nullable.toOption, questionsRef.current->Nullable.toOption) {
      | (Some(current), Some(_)) =>
        switch (height, width) {
        | (Some(_), _) =>
          switch currentQuestionRef.current->Nullable.toOption {
          | None => ()
          | Some(currentQuestion) =>
            current->Scroll.setTop(currentQuestion->Offset.top -. current->Offset.top)
          }
        | (_, Some(_)) =>
          switch currentQuestionRef.current->Nullable.toOption {
          | None => ()
          | Some(currentQuestion) =>
            current->Scroll.setLeft(currentQuestion->Offset.left -. current->Offset.left)
          }
        | _ => ()
        }
      | _ => ()
      }

      None
    }, (ref.current, questionsRef.current, currentQuestionRef.current, height, width, queryParams))

    let itemWrapperStyle = switch queryParams.calendar {
    | Some(Day) | None => "h-full shadow "
    | Some(HalfCycle) => "h-1/5 shadow overflow-hidden max-h-[20%] lg:h-auto lg:max-h-none border-b-2 border-x-2 border-default  lg:border-0 snap-start"
    | Some(Cycle) => "h-[10%] shadow overflow-hidden max-h-[10%] lg:max-h-none lg:h-auto border-b-2 border-x-2 border-default lg:border-0 snap-start"
    }

    let handlePageScroll = _ =>
      switch windowWidth {
      | LG(_) | XL(_) | XXL(_) =>
        %raw(`document.body.style.overflow = (document.body.style.overflow === "hidden") ? "auto":"hidden"`)
      | _ => ()
      }

    let questions =
      pastQuestions
      ->Array.concat(
        questions->Fragment.getConnectionNodes->Array.map(x => Question(x.fragmentRefs)),
      )
      ->Array.concat(seedQuestions)

    let chunkQuestionsByCalendar = array => {
      let chunkSize = switch queryParams.calendar {
      | Some(Day) | None => 1
      | Some(HalfCycle) => 5
      | Some(Cycle) => 10
      }
      Array.make(
        ~length=Math.ceil(array->Array.length->float /. float(chunkSize))->Float.toInt,
        React.null,
      )
      ->Array.mapWithIndex((_, index) => index * chunkSize)
      ->Array.map(start => array->Array.slice(~start, ~end=start + chunkSize))
    }

    let questionList =
      questions
      ->Array.mapWithIndex((question, index) => {
        let today =
          Date.make()->Date.toLocaleDateStringWithLocaleAndOptions("en-US", {dateStyle: #short})

        let selectedDay =
          queryParams.day->Option.map(day =>
            Date.toLocaleDateStringWithLocaleAndOptions(day, "en-US", {dateStyle: #short})
          )
        switch question {
        | Question(_) | SeedQuestion(_) =>
          let day =
            (Date.now() +.
            Helpers.Date.dayInMilliseconds *. float(index - pastQuestions->Array.length))
            ->Date.fromTime
            ->Date.toLocaleDateStringWithLocaleAndOptions("en-US", {dateStyle: #short})
            ->Some

          if day == selectedDay || (queryParams.day == None && day == Some(today)) {
            <li
              className=itemWrapperStyle
              ref={ReactDOM.Ref.domRef(currentQuestionRef)}
              key={index->Int.toString}>
              <Item question index />
            </li>
          } else {
            <li className=itemWrapperStyle key={index->Int.toString}>
              <Item question index />
            </li>
          }
        | PastQuestion({day}) =>
          let day =
            day
            ->Date.toLocaleDateStringWithLocaleAndOptions("en-US", {dateStyle: #short})
            ->Some
          if day == selectedDay {
            <li
              className=itemWrapperStyle
              ref={ReactDOM.Ref.domRef(currentQuestionRef)}
              key={index->Int.toString}>
              <Item question index />
            </li>
          } else {
            <li className=itemWrapperStyle key={index->Int.toString}>
              <Item question index />
            </li>
          }
        }
      })
      ->chunkQuestionsByCalendar

    <div
      className="h-full overflow-x-scroll overflow-y-hidden lg:max-h-none
      lg:overflow-y-scroll lg:overflow-x-auto lg:overscroll-contain py-4 pl-4 lg:pl-0
      hide-scrollbar lg:hover:border-2 border-primary-dark/50 lg:rounded-3xl lg:m-2
      snap-x lg:snap-none snap-mandatory first:scroll-pl-0 scroll-px-[2.5vw]"
      onMouseEnter={handlePageScroll}
      onMouseLeave={handlePageScroll}
      ref={ReactDOM.Ref.domRef(ref)}>
      <FramerMotion.Div
        layout=Position
        className="max-h-full h-full lg:max-h-none flex flex-row flex-wrap lg:flex-col
        lg:items-center justify-center px-2 pt-1 hover:lg:m-[-2px]"
        style={{
          height: `${height->Option.getWithDefault("")}`,
          width: `${width->Option.getWithDefault("")}`,
        }}>
        <div
          className="flex max-h-full lg:max-h-none flex-wrap lg:flex-nowrap
           lg:justify-center flex-col lg:w-full z-0 h-full lg:h-fit border-t-2 border-default lg:border-t-0 scroll-smooth "
          ref={ReactDOM.Ref.domRef(questionsRef)}>
          {questionList
          ->Array.mapWithIndex((chunk, index) =>
            <ul
              key={index->Int.toString}
              className="flex max-h-full lg:max-h-none lg:justify-center flex-col lg:w-full z-0  h-full lg:h-fit border-t-2 border-default lg:border-t-0 ">
              {chunk->React.array}
            </ul>
          )
          ->React.array}
        </div>
      </FramerMotion.Div>
    </div>
  }
}

module Query = %relay(`
  query QuestionsQuery {
    ...Questions_list
  }
`)

@react.component
let make = (~queryRef) => {
  let {queryParams, setParams} = Routes.Main.Questions.Route.useQueryParams()
  let data = Query.usePreloaded(~queryRef)
  let {setHeroComponent} = React.useContext(HeroComponentContext.context)

  open FramerMotion

  React.useEffect0(() => {
    setHeroComponent(_ =>
      <div
        className="lg:w-[50%] w-[80%] md:w-[70%] mx-[10%] md:mx-[15%] lg:mx-0 flex align-end lg:pr-20 min-h-[420px] ">
        <div className="w-full h-full flex flex-col items-center  p-4">
          <header className="pb-4 w-full px-4 ">
            <h1 className="text-6xl font-bold text-default-darker ">
              {"Question X"->React.string}
            </h1>
          </header>
          <div />
        </div>
      </div>
    )
    None
  })

  let handleCalendar = e => {
    let value = (e->ReactEvent.Form.target)["value"]
    let calendar = value->CalendarType.parse
    if calendar == queryParams.calendar {
      ()
    } else {
      setParams(
        ~removeNotControlledParams=false,
        ~navigationMode_=Replace,
        ~setter=currentParameters => {...currentParameters, calendar},
      )
    }
  }

  <FramerMotion.Div
    transition={{duration: 2.}} className="relative flex flex-col lg:mt-0 max-h-[558px] h-[558px] ">
    <div
      className=" w-full flex lg:flex-row-reverse lg:justify-between justify-start items-center pt-2 z-10 px-4 gap-4  ">
      <label>
        <select
          value={queryParams.calendar->Option.mapWithDefault("", CalendarType.serialize)}
          className="lg:hidden border-black/20 bg-transparent backdrop-blur-sm text-lg font-semibold rounded-xl"
          onChange={e => {
            e->handleCalendar
          }}>
          <QuestionsCalendarOptions />
        </select>
      </label>
      <input
        className="border-2 border-gray-300 bg-default-light lg:bg-secondary white backdrop-blur-md h-10 px-5 lg:pr-16 rounded-lg text-sm focus:outline-none"
        type_="search"
        name="search"
        placeholder="Search"
      />
    </div>
    <React.Suspense fallback={<> </>}>
      <List questions=data.fragmentRefs />
    </React.Suspense>
  </FramerMotion.Div>
}
