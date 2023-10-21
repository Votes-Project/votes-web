type question = {
  tokenId?: int,
  question: string,
  options: array<string>,
}

let questions = [
  {
    tokenId: 0,
    question: "What is the capital of France?",
    options: ["Paris", "London", "Berlin", "Madrid"],
  },
  {
    tokenId: 1,
    question: "What is the capital of India?",
    options: ["Delhi", "Mumbai", "Kolkata", "Chennai"],
  },
  {
    tokenId: 2,
    question: "What is the capital of Germany?",
    options: ["Berlin", "London", "Paris", "Madrid"],
  },
  {
    tokenId: 3,
    question: "What is the capital of France?",
    options: ["Paris", "London", "Berlin", "Madrid"],
  },
  {
    tokenId: 4,
    question: "What is the capital of India?",
    options: ["Delhi", "Mumbai", "Kolkata", "Chennai"],
  },
  {
    tokenId: 5,
    question: "What is the capital of Germany?",
    options: ["Berlin", "London", "Paris", "Madrid"],
  },
]

let communityQuestions = [
  {
    question: "What is the capital of France?",
    options: ["Paris", "London", "Berlin", "Madrid"],
  },
  {
    question: "What is the capital of India?",
    options: ["Delhi", "Mumbai", "Kolkata", "Chennai"],
  },
  {
    question: "What is the capital of Germany?",
    options: ["Berlin", "London", "Paris", "Madrid"],
  },
  {
    question: "What is the capital of France?",
    options: ["Paris", "London", "Berlin", "Madrid"],
  },
  {
    question: "What is the capital of India?",
    options: ["Delhi", "Mumbai", "Kolkata", "Chennai"],
  },
]

@react.component @relay.deferredComponent
let make = () => {
  let firstQuestion = questions->Array.get(0)
  switch firstQuestion {
  | Some(question) =>
    <div className="w-full pt-4">
      // <div className="flex flex-row justify-start items-center">
      //   <h1 className=" flex-1text-center text-3xl py-4 font-bold"> {"Queue"->React.string} </h1>
      // </div>

      <div
        className="lg:flex-[0_0_auto] lg:max-w-6xl m-auto flex flex-col lg:flex-row lg:justify-center lg:items-center flex-shrink-0 max-w-full">
        <div className="lg:w-[50%] w-[80%] md:w-[70%] mx-3 md:mx-4 lg:mx-0 flex align-end ">
          <div className="self-end w-full">
            <h2 className="text-xl font-semibold px-4"> {"Next Question"->React.string} </h2>
            <div> {question.question->React.string} </div>
            <ul>
              {question.options
              ->Array.mapWithIndex((option, index) => {
                <li key={index->Int.toString}> {option->React.string} </li>
              })
              ->React.array}
            </ul>
          </div>
        </div>
      </div>
      <div
        className="min-h-[558px] lg:flex-[0_0_auto] w-full !self-end bg-white pr-[5%] pb-0 lg:bg-transparent lg:w-[50%] lg:pr-20">
        <div className="py-4 w-full ">
          <h2 className="text-xl font-semibold px-4"> {"Voter Questions"->React.string} </h2>
          {questions
          ->Array.sliceToEnd(~start=1)
          ->Array.mapWithIndex((question, index) => {
            <div className="" key={index->Int.toString}>
              <div> {question.question->React.string} </div>
              <div
                className="mx-6 max-w-[180px] h-0 border bg-black  border-default-darker rounded-md opacity-20"
              />
            </div>
          })
          ->React.array}
        </div>
        <div className="py-4 w-full">
          <h2 className="text-xl font-semibold px-4"> {"Community Questions"->React.string} </h2>
          {communityQuestions
          ->Array.mapWithIndex((question, index) => {
            <div className="" key={index->Int.toString}>
              <div> {question.question->React.string} </div>
              <div
                className="mx-6 max-w-[180px] h-0 border bg-black  border-default-darker rounded-md opacity-20"
              />
            </div>
          })
          ->React.array}
        </div>
      </div>
    </div>

  | None => <div> {"No questions"->React.string} </div>
  }
}

//<div> {(questions->Array.length + index + 1)->Int.toString->React.string} </div>}
