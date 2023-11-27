type unhandledQuestionType = {
  id: string,
  title: string,
}

type question =
  | Question(RescriptRelay.fragmentRefs<[#Questions_item]>)
  | SeedQuestion(unhandledQuestionType)
  | PastQuestion(unhandledQuestionType)

let pastQuestions = [
  PastQuestion({
    id: "1",
    title: "How do I get started with Rescript?",
  }),
  PastQuestion({
    id: "2",
    title: "How do I get started with Rescript?",
  }),
  PastQuestion({
    id: "3",
    title: "How do I get started with Rescript?",
  }),
  PastQuestion({
    id: "4",
    title: "How do I get started with Rescript?",
  }),
  PastQuestion({
    id: "5",
    title: "How do I get started with Rescript?",
  }),
  PastQuestion({
    id: "6",
    title: "How do I get started with Rescript?",
  }),
]

let seedQuestions = [
  SeedQuestion({
    id: "a",
    title: "How do I get started with Relay",
  }),
  SeedQuestion({
    id: "b",
    title: "How do I get started with Relay",
  }),
  SeedQuestion({
    id: "c",
    title: "How do I get started with Relay",
  }),
  SeedQuestion({
    id: "d",
    title: "How do I get started with Relay",
  }),
  SeedQuestion({
    id: "e",
    title: "How do I get started with Relay",
  }),
  SeedQuestion({
    id: "f",
    title: "How do I get started with Relay",
  }),
  SeedQuestion({
    id: "g",
    title: "How do I get started with Relay",
  }),
  SeedQuestion({
    id: "h",
    title: "How do I get started with Relay",
  }),
  SeedQuestion({
    id: "i",
    title: "How do I get started with Relay",
  }),
  SeedQuestion({
    id: "j",
    title: "How do I get started with Relay",
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
      <button
        className=" flex-1 whitespace-pre-wrap [text-wrap:pretty] bg-default lg:bg-secondary shadow-lg p-2 rounded-lg self-start mr-auto">
        {question.title->React.string}
      </button>
    </div>
  }
}

module SeedQuestionItem = {
  @react.component
  let make = (~question) => {
    <div className="flex flex-col justify-center items-center">
      <button
        className=" flex-1 whitespace-pre-wrap [text-wrap:pretty] bg-default lg:bg-secondary shadow-lg p-2 rounded-lg self-start">
        {question.title->React.string}
      </button>
    </div>
  }
}

module PastQuestionItem = {
  @react.component
  let make = (~question) => {
    <div className="flex flex-col justify-center items-center">
      <button
        className=" flex-1 whitespace-pre-wrap [text-wrap:pretty] bg-default lg:bg-secondary opacity-50 shadow-lg p-2 rounded-lg self-start">
        {question.title->React.string}
      </button>
    </div>
  }
}

module Item = {
  @react.component
  let make = (
    ~question,
    ~index,
    ~controls: FramerMotion.Gestures.Drag.Controls.t<'event>,
    ~listSyntheticScrollY,
    ~setSyntheticScrollHeight,
  ) => {
    let ref = React.useRef(Nullable.null)
    let today = Date.now()->Date.fromTime
    let date =
      Date.make()
      ->Js.Date.setDate(float(today->Date.getDate + index))
      ->Date.fromTime

    let isClosestToTop = (current, scrollY) => {
      open Element
      scrollY > current->Offset.top && scrollY < current->Offset.top -. current->Offset.height
    }

    let isToday = today->Date.getTime == date->Date.getTime

    let day = date->Date.toLocaleStringWithLocaleAndOptions("en-us", {day: #"2-digit"})
    let weekday = date->Date.toLocaleStringWithLocaleAndOptions("en-us", {weekday: #short})

    let startDrag = event => {
      controls.start(event)
    }

    <div
      className="w-full flex flex-col justify-center items-center " ref={ReactDOM.Ref.domRef(ref)}>
      <div className="flex flex-1 flex-row gap-2 justify-end w-full items-stretch mr-auto">
        <FramerMotion.Div className="flex flex-col py-2 touch-scroll">
          {switch question {
          | Question(question) => <QuestionItem question />
          | SeedQuestion(question) => <SeedQuestionItem question />
          | PastQuestion(question) => <PastQuestionItem question />
          }}
        </FramerMotion.Div>
        <div
          onPointerDown={startDrag}
          className=" flex flex-col items-center cursor-row-resize touch-none min-w-[4rem]">
          <div
            className="select-none text-xs font-fugaz self-center rounded-full  text-default-darker">
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
    open FramerMotion
    let {questions} = Fragment.use(questions)
    let (syntheticScrollHeight, setSyntheticScrollHeight) = React.useState(() => 0.)
    let (dragConstraints, setDragConstraints) = React.useState(() => Gestures.Drag.Box({
      top: 0.,
      bottom: 0.,
    }))
    let width = Window.Width.Inner.use()

    let ref = React.useRef(Nullable.null)

    let controls = FramerMotion.Gestures.Drag.Controls.use()

    let y = Spring.use(0, ~config={damping: 4, stiffness: 110, mass: 0.1})

    let handlePageScroll = _ =>
      switch width {
      | LG | XL | XXL =>
        %raw(`document.body.style.overflow = (document.body.style.overflow === "hidden") ? "auto":"hidden"`)
      | _ => ()
      }

    let handleSyntheticScroll = e =>
      switch width {
      | LG | XL | XXL => y->FramerMotion.set(y->FramerMotion.get -. e->ReactEvent.Wheel.deltaY)
      | _ => ()
      }

    React.useEffect1(() => {
      open Element
      ref.current
      ->Nullable.toOption
      ->Option.map(current => {
        setDragConstraints(
          _ => Box({
            top: -0.5 *. (current->Scroll.height +. current->Offset.height),
            bottom: 0.5 *. (current->Scroll.height +. current->Offset.height),
          }),
        )
        current->parentNode->EventListener.make(Wheel, handleSyntheticScroll)
        () => current->parentNode->EventListener.remove(Wheel, handleSyntheticScroll)
      })
    }, [ref])

    let pastQuestions = pastQuestions->Array.mapWithIndex((question, index) => {
      let index = index - Array.length(pastQuestions)
      switch question {
      | PastQuestion({id}) =>
        <Item key=id question index controls listSyntheticScrollY=y setSyntheticScrollHeight />
      | _ => React.null
      }
    })

    let questions =
      questions
      ->Fragment.getConnectionNodes
      ->Array.mapWithIndex((question, index) => {
        <React.Suspense fallback={<div />}>
          <Item
            question=Question(question.fragmentRefs)
            index
            controls
            listSyntheticScrollY=y
            setSyntheticScrollHeight
            key=question.id
          />
        </React.Suspense>
      })

    let seedQuestions = seedQuestions->Array.mapWithIndex((question, index) => {
      switch question {
      | SeedQuestion({id}) =>
        <Item
          key=id
          question
          index={questions->Array.length + index}
          controls
          listSyntheticScrollY=y
          setSyntheticScrollHeight
        />
      | _ => React.null
      }
    })

    let questions =
      pastQuestions
      ->Array.concat(questions)
      ->Array.concat(seedQuestions)
      ->Array.mapWithIndex((question, index) => {
        let cycle = index / 10
        switch index {
        | index if index->mod(10) == 0 && cycle != 0 =>
          <>
            <div
              className="flex flex-row items-center justify-between w-full"
              key={`cycle-${cycle->Int.toString}`}>
              <p className="text-default-darker text-md font-bold">
                {`Cycle ${cycle->Int.toString}`->React.string}
              </p>
              <div className="flex-1 h-0 border border-default-darker" />
            </div>
            {question}
          </>
        | _ => question
        }
      })

    <div
      className="overflow-hidden  py-4 "
      onMouseEnter={handlePageScroll}
      onMouseLeave={handlePageScroll}>
      <FramerMotion.Div
        drag=Y
        dragConstraints
        dragListener=false
        dragControls=controls
        dragMomentum={false}
        ref={ReactDOM.Ref.domRef(ref)}
        style={{y: y}}
        className=" flex items-center justify-center flex-col w-full flex-1 h-full max-h-[420px] hide-scrollbar pt-10 z-0 ">
        {questions->React.array}
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

  <FramerMotion.Div transition={{duration: 2.}} className="relative flex flex-col mt-[-5%] lg:mt-0">
    <div className=" absolute top-0 w-full flex justify-start items-center pt-2 z-10 px-4 gap-4">
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
        className="border-2 border-gray-300 bg-default-light lg:bg-secondary white backdrop-blur-md h-10 px-5 pr-16 rounded-lg text-sm focus:outline-none"
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
