type choice = {
  value: string,
  correct: bool,
  details: string,
}
let longTitle = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu"
let choices = [
  {
    value: longTitle,
    correct: true,
    details: "The answer to life, the universe and everything",
  },
  {value: longTitle, correct: false, details: "The answer to life, the universe and everything"},
  {value: longTitle, correct: false, details: "The answer to life, the universe and everything"},
  {value: longTitle, correct: false, details: "The answer to life, the universe and everything"},
  {value: "42", correct: false, details: "The answer to life, the universe and everything"},
]

ReactModal.setAppElement("#root")

module QuestionTitle = {
  let titleStyle = titleLength => {
    if titleLength <= 50 {
      "text-4xl"
    } else if titleLength <= 100 {
      "text-2xl"
    } else if titleLength <= 150 {
      "text-xl"
    } else if titleLength <= 200 {
      "text-md"
    } else {
      "text-md"
    }
  }

  let title = longTitle
  @react.component
  let make = () => {
    <div className="pt-6">
      <h1
        className={`font-semibold text-default-darker pl-4 mb-6 ${titleStyle(
            title->String.length,
          )}`}>
        {title->React.string}
      </h1>
      <div
        className="mx-4 max-w-[180px] h-0 border-2 bg-black  border-default-darker rounded-md opacity-20"
      />
    </div>
  }
}
module QuestionHeader = {
  @react.component
  let make = () => {
    <div className="flex flex-col">
      <div
        className="font-semibold flex w-full justify-between items-center py-4 px-4 max-w-2xl text-sm">
        <p className="text-default-darker"> {"shedapp.eth"->React.string} </p>
        <div
          className="mx-3 max-w-[36px] h-0 flex-1 border-2 bg-black  border-default-darker rounded-md"
        />
        <p className="text-default-darker"> {"August 5 2023"->React.string} </p>
        <div
          className="mx-3 max-w-[36px] h-0 flex-1 border-2 bg-black border-default-darker rounded-md"
        />
        <p className="text-default-darker"> {"1000 Answers"->React.string} </p>
      </div>
      <QuestionTitle />
    </div>
  }
}

module ChoicesPage = {
  let titleStyle = titleLength => {
    if titleLength <= 50 {
      "text-3xl"
    } else if titleLength <= 100 {
      "text-xl"
    } else if titleLength <= 150 {
      "text-lg"
    } else if titleLength <= 200 {
      "text-md"
    } else {
      "text-md"
    }
  }
  @react.component
  let make = (~checkedIndex, ~handleChecked, ~handleVote) => {
    let choiceStyle = i =>
      checkedIndex == Some(i)
        ? "bg-active text-white shadow border border-active"
        : "text-default-darker shadow-inner bg-secondary border border-primary "

    <>
      <div className="flex flex-col justify-around items-center my-4 mr-4">
        {choices
        ->Array.mapWithIndex((option, i) => {
          <div
            className={`w-full  flex flex-row items-center mx-4 my-2 py-2 px-4 rounded-lg max-w-md min-h-[80px]  overflow-hidden ${choiceStyle(
                i,
              )} transition-all`}
            key={i->Int.toString}
            onClick={e => handleChecked(Some(e), i)}>
            <p className={`font-semibold text-left`}> {option.value->React.string} </p>
          </div>
        })
        ->React.array}
      </div>
      <div className="flex flex-col  justify-center items-center mb-6 gap-3">
        <button
          className="py-2 px-8 bg-active text-white rounded-lg text-2xl font-bold disabled:bg-background-light disabled:opacity-50"
          disabled={checkedIndex->Option.isNone}
          onClick={_ => handleVote()}>
          {"Vote"->React.string}
        </button>
        <button
          className="text-background-dark
              font-semibold
              underline
            ">
          {"Abstain"->React.string}
        </button>
      </div>
    </>
  }
}

module AnswerPage = {
  @react.component
  let make = (~checkedIndex) => {
    let selectedChoice = checkedIndex->Option.flatMap(i => choices->Array.get(i))

    <>
      <div
        className={`w-full  noises flex flex-row items-center my-4 py-8 px-4 rounded-lg max-w-md bg-active text-white`}>
        <label className="font-semibold">
          {Option.getExn(selectedChoice).value->React.string}
        </label>
      </div>
    </>
  }
}

@react.component @relay.deferredComponent
let make = () => {
  let (checkedIndex, setCheckedIndex) = React.useState(_ => None)
  let (hasAnswered, setHasAnswered) = React.useState(_ => false)

  let handleChecked = (e: option<ReactEvent.Mouse.t>, index) => {
    e->Option.map(ReactEvent.Mouse.stopPropagation)->ignore
    setCheckedIndex(_ => Some(index))
  }
  let handleVote = _ => {
    setHasAnswered(_ => true)
  }

  <>
    {hasAnswered
      ? <AnswerPage checkedIndex />
      : <ChoicesPage checkedIndex handleChecked handleVote />}
  </>
}
