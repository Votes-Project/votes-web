RescriptRelay.relayFeatureFlags.enableRelayResolvers = true

ReactModal.setAppElement("#root")

let asker = "0xf4bb53eFcFd49Fe036FdCc8F46D981203ae3BAB8"

module OptionsPage = {
  module Fragment = %relay(`
    fragment SingleQuestion_OptionsPage on Question {
      ...OptionsList_question
      ...QuestionTitle_question
      question
    }
  `)
  @react.component
  let make = (~question) => {
    let {question, fragmentRefs} = Fragment.use(question)

    let {setHeroComponent} = React.useContext(HeroComponentContext.context)
    let votesy = React.useContext(VotesySpeakContext.context)

    let {queryParams} = Routes.Main.Question.Route.useQueryParams()
    let answerRef = React.useCallback0(element => {
      switch element->Nullable.toOption {
      | Some(element) =>
        element->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: End})
      | None => ()
      }
    })

    let questionTextSize =
      question
      ->String.length
      ->QuestionTitle.size

    React.useEffect0(() => {
      setHeroComponent(_ =>
        <div
          className="flex flex-col justify-center items-center w-full p-4 lg:h-[420px] lg:min-h-[420px] min-h-[40vh]"
          ref={ReactDOM.Ref.callbackDomRef(answerRef)}>
          <div
            className="flex-1 flex items-end self-start text-xl font-semibold text-default-darker text-center ">
            <ShortAddress address=Some(asker) avatar=true />
          </div>
          <QuestionTitle
            question={fragmentRefs}
            className={`align-stretch font-bold flex-2 flex justify-center items-center [text-wrap:balance] text-center text-default-darker px-4  ${questionTextSize}`}
          />
        </div>
      )
      votesy.setPosition(_ => Fixed)
      votesy.setContent(_ =>
        <div className="text-md [text-wrap:pretty] py-2">
          {"Hi,\nI'm Votesy the Owl, and I like to vote!"->React.string}
        </div>->Some
      )

      None
    })

    <div className="flex-1 flex flex-col justify-center items-stretch h-full">
      {switch queryParams.answer {
      | Some(_) =>
        <h1
          className="text-2xl px-4 pt-2 text-default-darker lg:text-active text-center animate-pulse">
          {"Hold to Confirm"->React.string}
        </h1>
      | None =>
        <h1 className="text-2xl px-4 pt-2 text-default-dark lg:text-primary-dark text-center ">
          {"Pick an answer"->React.string}
        </h1>
      }}
      <ul className="flex flex-col justify-between items-start lg:px-6 mb-4 lg:mr-4">
        <OptionsList question={fragmentRefs} />
      </ul>
      <div className="flex flex-col justify-center items-center mb-6 gap-3" />
    </div>
  }
}

module QuestionQuery = %relay(`
  query SingleQuestionQuery($id: ID!) {
    node(id: $id) {
      ... on Question {
        day
        ...SingleQuestion_OptionsPage
        ...QuestionTitle_question
        ...QuestionAnswer_question
      }
    }
  }
`)

module AnswerQuery = %relay(`
  query SingleQuestion_AnswerQuery($day: Int!, $contextId: ID!) {
    userById(id: $contextId) {
      answers(condition: { day: $day }) {
        nodes {
          ...QuestionAnswer_answer
        }
      }
    }
  }
`)

@react.component @relay.deferredComponent
let make = (~queryRef) => {
  let contextId = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_contextId")
  let {node: question} = QuestionQuery.usePreloaded(~queryRef)
  let day = switch question {
  | Some(Question({day})) => day->Option.map(BigInt.toInt)->Option.getWithDefault(-1)
  | _ => -1
  }
  let {userById: user} = AnswerQuery.use(
    ~variables={
      day,
      contextId: contextId->Option.getWithDefault(""),
    },
  )

  let answer = user->Option.flatMap(u => u.answers.nodes->Array.get(0))->Option.flatMap(a => a)

  switch (answer, question) {
  | (None, Some(Question({fragmentRefs}))) => <OptionsPage question={fragmentRefs} />
  | (Some({fragmentRefs}), Some(Question({fragmentRefs: questionFragmentRefs}))) =>
    <QuestionAnswer question={questionFragmentRefs} answer={fragmentRefs} />
  | _ => React.null
  }
}
