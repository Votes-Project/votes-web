%%raw(`import 'react-vertical-timeline-component/style.min.css'`)

module VerticalTimeline = {
  type layout =
    | @as("1-column-left") OneLeft | @as("1-column-right") OneRight | @as("2-columns") Two
  @react.component @module("react-vertical-timeline-component")
  external make: (
    ~children: React.element,
    ~className: string=?,
    ~lineColor: string=?,
    ~layout: layout=?,
  ) => React.element = "VerticalTimeline"

  module Element = {
    @react.component @module("react-vertical-timeline-component")
    external make: (
      ~className: string=?,
      ~contentStyle: ReactDOM.Style.t=?,
      ~contentArrowStyle: ReactDOM.Style.t=?,
      ~date: string=?,
      ~iconStyle: ReactDOM.Style.t=?,
      ~icon: React.element=?,
      ~iconClassname: string=?,
      ~dateClassname: string=?,
      ~textClassName: string=?,
      ~children: React.element,
    ) => React.element = "VerticalTimelineElement"
  }
}

module Query = %relay(`
  query QuestionsQuery {
    auctionSettleds {
      edges {
        node {
          id
          tokenId
        }
      }
    }
  }
`)

type question = {
  id: string,
  tokenId: string,
  startTime: float,
  content: string,
}

let questions = [
  {
    id: "1",
    tokenId: "1",
    startTime: 0.0,
    content: "What is the best programming language?",
  },
  {
    id: "2",
    tokenId: "2",
    startTime: 1.0,
    content: "What is the best programming language?",
  },
  {
    id: "3",
    tokenId: "3",
    startTime: 2.0,
    content: "What is the best programming language?",
  },
  {
    id: "4",
    tokenId: "4",
    startTime: 3.0,
    content: "What is the best programming language?",
  },
]

@react.component
let make = (~queryRef) => {
  let _ = Query.usePreloaded(~queryRef)
  <React.Suspense fallback={<div> {React.string("Loading Qustions...")} </div>}>
    <div className="bg-background flex flex-col px-4 py-6 shadow-inner">
      <h1 className="text-5xl font-bold text-default-darker pl-4"> {"Questions"->React.string} </h1>
      <div className="w-full flex justify-center items-center pb-6">
        <input
          className="border-2 border-gray-300 bg-white h-10 px-5 pr-16 rounded-lg text-sm focus:outline-none"
          type_="search"
          name="search"
          placeholder="Search"
        />
      </div>
      <VerticalTimeline className="!pt-0" lineColor="#828AB5" layout={OneLeft}>
        {questions
        ->Array.map(question => {
          <VerticalTimeline.Element
            iconStyle={{backgroundColor: "#828AB5", border: "none"}}
            date={question.startTime->Date.fromTime->Date.toDateString}>
            <h3 className="vertical-timeline-element-title"> {question.content->React.string} </h3>
          </VerticalTimeline.Element>
        })
        ->React.array}
      </VerticalTimeline>
    </div>
  </React.Suspense>
}
