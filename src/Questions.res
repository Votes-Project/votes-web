type unhandledQuestionType = {
  id: string,
  title: string,
  day: int,
}

type question =
  | Question(RescriptRelay.fragmentRefs<[#Questions_item]>)
  | SeedQuestion(unhandledQuestionType)
  | PastQuestion(unhandledQuestionType)

let pastQuestions = [
  PastQuestion({
    id: "1",
    title: "Past Question stand in",
    day: 0,
  }),
  PastQuestion({
    id: "2",
    title: "Past Question stand in",
    day: 1,
  }),
  PastQuestion({
    id: "3",
    title: "Past Question stand in",
    day: 2,
  }),
  PastQuestion({
    id: "4",
    title: "Past Question stand in",
    day: 3,
  }),
  PastQuestion({
    id: "5",
    title: "Past Question stand in",
    day: 4,
  }),
  PastQuestion({
    id: "6",
    title: "Past Question stand in",
    day: 5,
  }),
]

let seedQuestions = [
  SeedQuestion({
    id: "a",
    title: "Seed Question stand in.",
    day: 100,
  }),
  SeedQuestion({
    id: "b",
    title: "Seed Question stand in.",
    day: 101,
  }),
  SeedQuestion({
    id: "c",
    title: "Seed Question stand in.",
    day: 102,
  }),
  SeedQuestion({
    id: "d",
    title: "Seed Question stand in.",
    day: 103,
  }),
]

module QuestionItem = {
  module Fragment = %relay(`
  fragment Questions_item on Question {
    id
    title
    tokenId
  }
`)

  @react.component
  let make = (~question) => {
    let question = Fragment.use(question)
    <div className="flex flex-col justify-center items-center">
      <div
        className=" flex-1 whitespace-pre-wrap [text-wrap:pretty] lg:bg-secondary lg:shadow-lg p-2 rounded-lg self-start mr-auto">
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
  let make = (~question) => {
    <div className="flex flex-col justify-center items-center">
      <div
        className=" flex-1 whitespace-pre-wrap [text-wrap:pretty]  lg:bg-secondary opacity-50 lg:shadow-lg p-2 rounded-lg self-start">
        {question.title->React.string}
      </div>
    </div>
  }
}

type calendarType = Day | HalfCycle | Cycle
module Item = {
  @react.component
  let make = (~question, ~index) => {
    let windowWidth = Window.Width.Inner.use()
    let {setParams} = Routes.Main.Questions.Route.useQueryParams()
    let ref = React.useRef(Nullable.null)
    let today = Date.now()->Date.fromTime
    let date =
      Date.make()
      ->Js.Date.setDate(float(today->Date.getDate + index))
      ->Date.fromTime

    let isToday = today->Date.getTime == date->Date.getTime
    let day = date->Date.toLocaleStringWithLocaleAndOptions("en-us", {day: #"2-digit"})
    let weekday = date->Date.toLocaleStringWithLocaleAndOptions("en-us", {weekday: #short})
    let handleQuestionSelect = _ => {
      setParams(~removeNotControlledParams=false, ~navigationMode_=Replace, ~setter=c => {
        ...c,
        day: switch question {
        | Question(_) => (pastQuestions->Array.length + index)->Some
        | SeedQuestion({day}) | PastQuestion({day}) => Some(day)
        },
      })
    }

    let calendarType = HalfCycle
    let className = switch (windowWidth, calendarType) {
    | (
        LG | XL | XXL,
        _,
      ) => "mx-1 p-2 min-w-0 w-full flex flex-col justify-center items-center snap-start"
    | (
        _,
        Day,
      ) => "w-[90vw] max-w-[90vw] min-w-[90vw] border-b-2 border-x-2 border-default rounded-b-2xl
     lg:border-0 mx-1 p-2 lg:min-w-0 lg:w-full flex lg:flex-col lg:justify-center
     lg:items-center snap-start"
    | (_, HalfCycle) => "w-[18w] max-w-[20vw] min-w-[20vw] max-h-[10rem] overflow-hidden
    border-b-2 border-x-2  border-default rounded-b-2xl lg:border-0 mx-1 p-2 lg:min-w-0 lg:w-full
    flex lg:flex-col lg:justify-center lg:items-center snap-start"
    | (
        _,
        Cycle,
      ) => "w-[9vw] max-h-[15rem] min-w-[15vw] overflow-hidden border-b-2 border-x-2  border-default
     rounded-b-2xl lg:border-0 mx-1 p-2 lg:min-w-0 lg:w-full flex lg:flex-col
     lg:justify-center lg:items-center snap-start"
    }

    <button className onClick=handleQuestionSelect ref={ReactDOM.Ref.domRef(ref)}>
      <div
        className="flex lg:flex-1 flex-col-reverse lg:flex-row gap-2 justify-end lg:w-full items-stretch  lg:mr-auto font-semibold  ">
        <FramerMotion.Div className="flex flex-col py-2">
          {switch question {
          | Question(question) => <QuestionItem question />
          | SeedQuestion(question) => <SeedQuestionItem question />
          | PastQuestion(question) => <PastQuestionItem question />
          }}
        </FramerMotion.Div>
        <div
          className="flex flex-col items-start lg:items-center lg:min-w-[4rem]  min-w-[2rem] lg:min-h-0">
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
    let pastQuestionsRef = React.useRef(Nullable.null)
    let questionsRef = React.useRef(Nullable.null)
    let seedQuestionsRef = React.useRef(Nullable.null)
    let currentQuestionRef = React.useRef(Nullable.null)

    React.useEffect7(() => {
      switch (
        ref.current->Nullable.toOption,
        pastQuestionsRef.current->Nullable.toOption,
        questionsRef.current->Nullable.toOption,
        seedQuestionsRef.current->Nullable.toOption,
      ) {
      | (Some(current), Some(pastQuestions), Some(questions), Some(seedQuestions)) =>
        switch windowWidth {
        | LG | XL | XXL =>
          open Element
          let height =
            pastQuestions->Offset.height +.
            questions->Offset.height +.
            seedQuestions->Offset.height +.
            current->Offset.height *. 2.
          setHeight(_ => Some(Float.toString(height) ++ "px"))
          setWidth(_ => None)
        | XS | SM | MD =>
          open Element
          let questionsWidth =
            pastQuestions->Offset.width +. questions->Offset.width +. seedQuestions->Offset.width
          let width = questionsWidth +. current->Offset.width *. 2.

          setWidth(_ => Some(width->Float.toString ++ "px"))
          setHeight(_ => None)
        }
      | _ => ()
      }
      None
    }, (ref, pastQuestionsRef, questionsRef, seedQuestionsRef, setHeight, windowWidth, setWidth))

    React.useEffect6(() => {
      open Element
      switch (ref.current->Nullable.toOption, questionsRef.current->Nullable.toOption) {
      | (Some(current), Some(questions)) =>
        switch (height, width) {
        | (Some(_), _) =>
          switch currentQuestionRef.current->Nullable.toOption {
          | None => current->Scroll.setTop(questions->Offset.top -. current->Offset.top)
          | Some(currentQuestion) =>
            current->Scroll.setTop(currentQuestion->Offset.top -. current->Offset.top)
          }
        | (_, Some(_)) =>
          switch currentQuestionRef.current->Nullable.toOption {
          | None => current->Scroll.setLeft(questions->Offset.left -. current->Offset.left)
          | Some(currentQuestion) =>
            current->Scroll.setLeft(currentQuestion->Offset.left -. current->Offset.left)
          }
        | _ => ()
        }
      | _ => ()
      }

      None
    }, (ref, questionsRef, currentQuestionRef, height, width, queryParams.day))

    let handlePageScroll = _ =>
      switch windowWidth {
      | LG | XL | XXL =>
        %raw(`document.body.style.overflow = (document.body.style.overflow === "hidden") ? "auto":"hidden"`)
      | _ => ()
      }

    let pastQuestions = pastQuestions->Array.mapWithIndex((question, index) => {
      let index = index - Array.length(pastQuestions)
      switch (question, queryParams.day) {
      | (PastQuestion({id, day}), Some(currentQuestionDay)) if day == currentQuestionDay =>
        <li ref={ReactDOM.Ref.domRef(currentQuestionRef)} key=id>
          <Item question index />
        </li>

      | (PastQuestion({id}), _) =>
        <li key=id>
          <Item question index />
        </li>
      | _ => React.null
      }
    })

    let questions =
      questions
      ->Fragment.getConnectionNodes
      ->Array.mapWithIndex((question, index) => {
        let day = pastQuestions->Array.length + index
        switch queryParams.day {
        | Some(currentQuestionDay) if day == currentQuestionDay =>
          <li ref={ReactDOM.Ref.domRef(currentQuestionRef)} key=question.id>
            <Item question=Question(question.fragmentRefs) index />
          </li>
        | _ =>
          <li key=question.id>
            <Item question=Question(question.fragmentRefs) index />
          </li>
        }
      })

    let seedQuestions = seedQuestions->Array.mapWithIndex((question, index) => {
      switch (question, queryParams.day) {
      | (SeedQuestion({id, day}), Some(currentQuestionDay)) if day == currentQuestionDay =>
        <li ref={ReactDOM.Ref.domRef(currentQuestionRef)} key=id>
          <Item index={questions->Array.length + index} question />
        </li>
      | (SeedQuestion({id}), _) =>
        <li key=id>
          <Item question index={questions->Array.length + index} />
        </li>
      | _ => React.null
      }
    })

    <div
      className="h-fit overflow-scroll lg:overscroll-contain py-4 pl-4 lg:pl-0 hide-scrollbar lg:hover:border-2  border-primary-dark/50 lg:rounded-3xl m-2 snap-x lg:snap-none snap-mandatory first:scroll-pl-0 scroll-px-[2.5vw]"
      onMouseEnter={handlePageScroll}
      onMouseLeave={handlePageScroll}
      ref={ReactDOM.Ref.domRef(ref)}>
      <FramerMotion.Div
        layout=Position
        className="flex flex-row lg:flex-col lg:items-center justify-center px-2 pt-1 hover:lg:m-[-2px] h-full "
        style={{
          height: `${height->Option.getWithDefault("auto")}`,
          width: `${width->Option.getWithDefault("auto")}`,
        }}>
        <ul
          className="flex  justify-center flex-row lg:flex-col lg:w-full z-0 h-fit border-t-2 border-default lg:border-t-0  "
          ref={ReactDOM.Ref.domRef(pastQuestionsRef)}>
          {pastQuestions->React.array}
        </ul>
        <ul
          ref={ReactDOM.Ref.domRef(questionsRef)}
          className="flex  justify-center flex-row lg:flex-col lg:w-full z-0  h-fit border-t-2 border-default lg:border-t-0 ">
          {questions->React.array}
        </ul>
        <ul
          className="flex justify-center flex-row lg:flex-col lg:w-full z-0  h-fit border-t-2 border-default lg:border-t-0 "
          ref={ReactDOM.Ref.domRef(seedQuestionsRef)}>
          {seedQuestions->React.array}
        </ul>
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

  <FramerMotion.Div
    transition={{duration: 2.}} className="relative flex flex-col lg:mt-0 max-h-[558px] ">
    <div
      className=" w-full flex lg:flex-row-reverse lg:justify-between justify-start items-center pt-2 z-10 px-4 gap-4  ">
      <label>
        <select
          value={""}
          className="border-black/20 bg-default-light text-lg font-semibold rounded-xl"
          onChange={_ => {
            ()
          }}>
          <option className="hidden" value=""> {"Sort By"->React.string} </option>
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
