@send
external addEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "addEventListener"
@send
external removeEventListener: (Dom.document, [#keypress | #keydown], 'a => unit) => unit =
  "removeEventListener"

type choice = {
  value: string,
  correct: bool,
  details: string,
}
let choices = [
  {value: "42", correct: true, details: "The answer to life, the universe and everything"},
  {value: "0", correct: false, details: "The answer to life, the universe and everything"},
  {value: "1", correct: false, details: "The answer to life, the universe and everything"},
  {value: "2", correct: false, details: "The answer to life, the universe and everything"},
]

let longTitle = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu"

ReactModal.setAppElement("#root")

module QuestionHeader = {
  @react.component
  let make = () => {
    <div
      className="font-semibold flex w-full justify-between items-center pt-6 pb-8 px-4 max-w-2xl text-sm">
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
  }
}

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

  let title = "Lorem ipsum dolor "
  @react.component
  let make = () => {
    <div>
      <h1
        className={`font-semibold text-default-darker pl-4 mb-6 ${titleStyle(
            title->String.length,
          )}`}>
        {title->React.string}
      </h1>
      <div
        className="mx-4 max-w-[240px] h-0  border-2 bg-black  border-default-darker rounded-md"
      />
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
      <QuestionTitle />
      <div className="flex flex-col justify-around items-center my-4 mr-4">
        {choices
        ->Array.mapWithIndex((option, i) => {
          <div
            className={`w-full  flex flex-row items-center mx-4 my-2 py-8 px-4 rounded-lg max-w-md ${choiceStyle(
                i,
              )} transition-all`}
            key={i->Int.toString}
            onClick={_ => handleChecked(i)}>
            <input
              className={`bg-background-dark checked:bg-primary checked:text-primary focus:ring-0 mr-4 outline-none border-none h-5 w-5 `}
              type_="radio"
              name="answer"
              value={option.value}
              checked={checkedIndex == Some(i)}
            />
            <label className="font-semibold"> {option.value->React.string} </label>
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
      <QuestionTitle />
      <div
        className={`w-full  noises flex flex-row items-center my-4 py-8 px-4 rounded-lg max-w-md bg-active text-white`}>
        <input
          className={`bg-background-dark  text-primary mr-4 outline-none h-8 w-8`}
          type_="radio"
          name="answer"
          value={Option.getExn(selectedChoice).value}
          defaultChecked={true}
        />
        <label className="font-semibold">
          {Option.getExn(selectedChoice).value->React.string}
        </label>
      </div>
    </>
  }
}

@react.component @relay.deferredComponent
let make = () => {
  open ReactModalSheet
  let {replace} = RelayRouter.Utils.useRouter()
  let {queryParams} = Routes.Main.Route.useQueryParams()
  let (isOpen, setIsOpen) = React.useState(_ => true)

  let onClose = _ => setIsOpen(_ => false)
  let onCloseEnd = _ => Routes.Main.Route.makeLinkFromQueryParams(queryParams)->replace

  let (checkedIndex, setCheckedIndex) = React.useState(_ => None)
  let (hasAnswered, setHasAnswered) = React.useState(_ => false)

  let handleChecked = index => {
    setCheckedIndex(_ => Some(index))
  }
  let handleVote = _ => {
    setHasAnswered(_ => true)
  }

  React.useEffect0(() => {
    let handleKeyDown = (e: ReactEvent.Keyboard.t) => {
      switch e->ReactEvent.Keyboard.key {
      | "Escape" => Routes.Main.Route.makeLinkFromQueryParams(queryParams)->replace
      | _ => ()
      }
    }
    document->addEventListener(#keydown, handleKeyDown)

    Some(() => document->removeEventListener(#keydown, handleKeyDown))
  })

  <>
    <Sheet className="md:hidden flex" isOpen onClose onCloseEnd rootId={"root"} snapPoints={[0.75]}>
      <Sheet.Container className="min-h-[864px]">
        <Sheet.Header className="bg-secondary noise flex justify-center ">
          <QuestionHeader />
        </Sheet.Header>
        <Sheet.Content
          className="bg-secondary noise px-4 h-full w-full flex flex-col justify-around ">
          {hasAnswered
            ? <AnswerPage checkedIndex />
            : <ChoicesPage checkedIndex handleChecked handleVote />}
        </Sheet.Content>
      </Sheet.Container>
      <Sheet.Backdrop onTap={onClose} />
    </Sheet>
    <ReactModal
      isOpen
      onRequestClose={onClose}
      className="hidden md:flex "
      style={
        overlay: {
          backgroundColor: "rgba(0,0,0,0.5)",
          outline: "none",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        },
        content: {
          outline: "none",
        },
      }>
      <div className="justify-center items-center flex inset-0 z-50 ">
        <div className="relative w-auto mx-auto max-w-3xl">
          <div
            className="flex flex-col border-0 rounded-xl shadow-xl relative w-full bg-secondary justify-center items-center min-w-[740px] min-h-[740px] noise">
            <QuestionHeader />
            <div className="bg-secondary w-full px-4 h-full flex flex-col justify-around noise">
              {hasAnswered
                ? <AnswerPage checkedIndex />
                : <ChoicesPage checkedIndex handleChecked handleVote />}
            </div>
          </div>
        </div>
      </div>
    </ReactModal>
  </>
}
