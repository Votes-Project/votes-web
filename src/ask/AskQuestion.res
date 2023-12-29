@module("/src/abis/Questions.json") external questionsContractAbi: JSON.t = "default"

let makeDiscordCommand = (title, options: array<QuestionUtils.questionOption>) => {
  let command = "/poll"

  let question = `question:${title}`

  let answers = options->Array.mapWithIndex((option, i) => {
    `answer${(i + 1)->Int.toString}:${option.option->Option.getExn}`
  })

  command ++ " " ++ question ++ " " ++ answers->Array.joinWith(" ")
}

let maxOptions = 5

module LinkVoteList = {
  module VoteConnectionFragment = %relay(`
  fragment AskQuestion_LinkVoteList_connection on VoteConnection {
    nodes {
      id
      tokenId
      question {
        state
      }
    }
  }

`)

  @react.component
  let make = (~voteConnection) => {
    let {nodes: votes} = VoteConnectionFragment.use(voteConnection)
    votes
    ->Array.filterMap(vote =>
      switch vote {
      | Some({question: Some({state: Used})}) => None
      | Some({tokenId, id}) =>
        Some(
          <option key={id} value={tokenId->BigInt.toString}>
            {tokenId->BigInt.toString->React.string}
          </option>,
        )
      | None => None
      }
    )
    ->React.array
  }
}

module Header = {
  module Fragment = %relay(`
  fragment AskQuestion_Header_connection on VoteConnection {
    ...AskQuestion_LinkVoteList_connection
    nodes {
      tokenId
      question {
        question
      }
    }
  }
`)

  @react.component
  let make = (~voteConnection, ~dispatch) => {
    let voteConnection = Fragment.useOpt(voteConnection)
    let {setParams, queryParams} = Routes.Main.Question.Ask.Route.useQueryParams()

    let {openConnectModal} = RainbowKit.useConnectModal()
    let {address} = Wagmi.Account.use()

    let handleSelectVote = e => {
      let value = ReactEvent.Form.currentTarget(e)["value"]
      let linkedVote = switch (voteConnection, value) {
      | (Some({nodes}), Some(useVote)) =>
        nodes
        ->Array.find(vote =>
          vote
          ->Option.map(v => v.tokenId->BigInt.toString === useVote)
          ->Option.getWithDefault(false)
        )
        ->Option.flatMap(vote => vote)
      | _ => None
      }

      let question =
        linkedVote
        ->Option.flatMap(({question}) => question)
        ->Option.map(({question}) => question)

      setParams(
        ~navigationMode_=Replace,
        ~removeNotControlledParams=false,
        ~setter=c => {
          ...c,
          question,
          useVote: Int.fromString(value),
        },
        ~onAfterParamsSet=({question}) => {
          question->AskContext.SetQuestionByHex->dispatch
        },
      )
    }

    <header className="w-full flex justify-between items-center  hide-scrollbar">
      {switch (address->Nullable.toOption, voteConnection) {
      | (Some(address), Some(voteConnection)) =>
        <div className="flex flex-row items-center gap-4 text-sm font-semibold">
          <ShortAddress address=Some(address) avatar=true />
          <React.Suspense
            fallback={<select
              className="border-black/20 bg-transparent backdrop-blur-sm p-1 text-sm border font-semibold rounded-xl">
              <option className="hidden" value=""> {"Loading..."->React.string} </option>
            </select>}>
            <label>
              <select
                onChange={handleSelectVote}
                value={queryParams.useVote->Option.mapWithDefault("", Int.toString)}
                className="border-black/20 bg-transparent backdrop-blur-sm p-1 text-sm border font-semibold rounded-xl">
                <option className="hidden" value=""> {"Link Vote"->React.string} </option>
                <option value=""> {"Seed"->React.string} </option>
                <LinkVoteList voteConnection={voteConnection.fragmentRefs} />
              </select>
            </label>
          </React.Suspense>
        </div>
      | _ =>
        <div className="flex flex-row items-center gap-2">
          <ReactIcons.LuHeart />
          <label>
            <select
              onClick={_ => openConnectModal()}
              className="border-black/20 bg-transparent backdrop-blur-sm text-sm p-1 border font-semibold rounded-xl">
              <option className="hidden" value=""> {"Link Vote"->React.string} </option>
            </select>
          </label>
        </div>
      }}
      <div className="flex flex-row items-center gap-2 " />
    </header>
  }
}

exception ContractWriteDoesNotExist
module EditButton = {
  module Query = %relay(`
  query AskQuestion_AskButton_Query($questionsContractAddress: ID!) {
    questionsContract(id: $questionsContractAddress) {
      editFee
    }
  }
`)

  @react.component
  let make = (~canSubmit) => {
    let {queryParams} = Routes.Main.Question.Ask.Route.useQueryParams()
    let {questionsContract} = Query.use(
      ~fetchPolicy=StoreOrNetwork,
      ~variables={
        questionsContractAddress: Environment.questionsContractAddress,
      },
    )

    let {config} = Wagmi.usePrepareContractWrite(
      ~config={
        address: Environment.questionsContractAddress,
        abi: questionsContractAbi,
        value: questionsContract->Option.mapWithDefault(BigInt.fromInt(0), q => q.editFee),
        functionName: "edit",
        args: (queryParams.useVote, queryParams.question),
        enabled: canSubmit && queryParams.useVote->Option.isSome,
      },
    )

    let edit = Wagmi.useContractWrite({
      ...config,
      onSuccess: _ => {
        ()
      },
    })

    let handleEdit = _ =>
      switch edit.write {
      | Some(edit) => edit()
      | None => raise(ContractWriteDoesNotExist)
      }

    <button
      onClick=handleEdit
      disabled={!canSubmit}
      className="mb-auto min-w-[8rem] min-h-[3rem] font-bold disabled:bg-default-disabled disabled:text-default-darker disabled:opacity-50 disabled:scale-100 rounded-2xl max-w-xs self-center bg-default-darker lg:bg-active text-white transition-all ease-linear hover:scale-105  ">
      {"Edit"->React.string}
    </button>
  }
}

module SubmitButton = {
  @react.component
  let make = (~canSubmit) => {
    let {queryParams} = Routes.Main.Question.Ask.Route.useQueryParams()

    let {config} = Wagmi.usePrepareContractWrite(
      ~config={
        address: Environment.questionsContractAddress,
        abi: questionsContractAbi,
        value: BigInt.fromInt(0),
        functionName: "submit",
        args: (queryParams.useVote, queryParams.question),
        enabled: canSubmit && queryParams.useVote->Option.isSome,
      },
    )

    let submit = Wagmi.useContractWrite({
      ...config,
      onSuccess: _ => {
        ()
      },
    })

    let handleSubmit = _ =>
      switch submit.write {
      | Some(submit) => submit()
      | None => raise(ContractWriteDoesNotExist)
      }

    <button
      onClick=handleSubmit
      disabled={!canSubmit}
      className="mb-auto min-w-[8rem] min-h-[3rem] font-bold disabled:bg-default-disabled disabled:text-default-darker disabled:opacity-50 disabled:scale-100 rounded-2xl max-w-xs self-center bg-default-darker lg:bg-active text-white transition-all ease-linear hover:scale-105  ">
      {"Ask"->React.string}
    </button>
  }
}

module Query = %relay(`
  query AskQuestion_Query($owner: Bytes!, $skipVoteConnection: Boolean!) {
    voteConnection(
      where: { owner: $owner }
      orderBy: tokenId
      orderDirection: asc
    ) @skip(if: $skipVoteConnection) {
      nodes {
        tokenId
        question {
          state
          question # Need question field here for some reason
        }
      }
      ...AskQuestion_Header_connection
    }
  }
`)

@react.component @relay.deferredComponent
let make = () => {
  let {setParams, queryParams} = Routes.Main.Question.Ask.Route.useQueryParams()
  let (state, dispatch) = React.useReducer(
    AskContext.reducer,
    {
      question: QuestionUtils.parseHexQuestion(queryParams.question)->Option.getWithDefault(
        QuestionUtils.emptyQuestion,
      ),
    },
  )

  let {address} = Wagmi.Account.use()

  let {voteConnection} = Query.use(
    ~fetchPolicy=StoreOrNetwork,
    ~variables={
      owner: address->Nullable.getWithDefault(""),
      skipVoteConnection: address->Nullable.toOption->Option.isNone,
    },
  )

  let linkedVote = voteConnection->Option.flatMap(({nodes}) =>
    nodes
    ->Array.find(vote =>
      vote
      ->Option.map(v => v.tokenId->BigInt.toInt->Some === queryParams.useVote)
      ->Option.getWithDefault(false)
    )
    ->Option.flatMap(vote => vote)
  )

  let votesy = React.useContext(VotesySpeakContext.context)

  let {options, title} = state.question
  let canSubmit = switch (options, title) {
  | (options, Some(_))
    if Array.length(options) >= 2 &&
      options->Array.every(({?option}) => option->Option.isSome) => true
  | _ => false
  }

  let askRef = React.useCallback0(element => {
    switch element->Nullable.toOption {
    | Some(element) =>
      element->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: End})
    | None => ()
    }
  })

  React.useEffect1(() => {
    let question = state.question->JSON.stringifyAny->Option.map(Viem.toHexFromString)
    setParams(~navigationMode_=Replace, ~removeNotControlledParams=false, ~setter=c => {
      ...c,
      question,
    })
    None
  }, [state])

  let titleRef = React.useRef("")

  let {setHeroComponent} = React.useContext(HeroComponentContext.context)

  let onTitleChange = e => {
    open SanitizeHtml
    let sanitizeConfig = {
      allowedTags: ["b", "i", "em", "strong", "a", "p", "h1"],
      allowedAttributes: {"a": ["href"]},
    }

    titleRef.current = SanitizeHtml.make((e->ReactEvent.Form.target)["value"], sanitizeConfig)

    ChangeTitle(titleRef.current)->dispatch
  }

  let handleAddOption = _ =>
    switch Array.length(options) {
    | length if length < 5 => AddOption->dispatch
    | _ => MaxOptionsReached->dispatch
    }

  let saveCommandToClipboard = (title, options) => {
    makeDiscordCommand(title, options)->Clipboard.writeText
    votesy.setContent(_ => {
      <div
        className="p-4 rounded-lg flex flex-col gap-2 items-center font-bold backdrop-opacity-20 backdrop-blur-sm">
        <p className="text-center text-md text-semibold text-default-darker">
          {"Your question was saved to your clipboard!"->React.string}
        </p>
        <a href="https://discord.gg/uwqMn3rxxj" target="_blank" rel="noopener">
          <button
            className=" bg-indigo-500 p-2 rounded-lg text-center text-md text-semibold text-default-light">
            {"Go to Discord"->React.string}
          </button>
        </a>
      </div>->Some
    })
  }

  let handleTitleFocus = _ => {
    open Document
    document
    ->getElementById("create-vote-title")
    ->Element.Scroll.intoViewWithOptions(~options={behavior: Smooth, block: End})
  }

  React.useEffect4(() => {
    setHeroComponent(_ =>
      <div
        className="p-4 w-full flex-1 flex justify-center items-center backdrop-blur-[2px] "
        ref={ReactDOM.Ref.callbackDomRef(askRef)}>
        <div
          className="flex flex-col items-start w-full p-4 border-2  pb-2 border-primary shadow-lg bg-default-light flex-1 relative focus-within:border-2 focus-within:ring-0 rounded-xl transition-all duration-200 ease-linear">
          <Header voteConnection={voteConnection->Option.map(vc => vc.fragmentRefs)} dispatch />
          <ContentEditable
            id="create-vote-title"
            editablehasplaceholder="true"
            placeholder="Ask question..."
            html={state.question.title->Option.getWithDefault("")}
            onChange={onTitleChange}
            onFocus={handleTitleFocus}
            className="w-[90vw] lg:w-auto min-h-[300px] max-w-md lg:p-4 p-2 border-none focus:ring-0 break-words bg-transparent cursor-pointer text-wrap focus:cursor-text focus:text-left text-xl lg:text-2xl transition-all duration-300 ease-linear "
          />
        </div>
      </div>
    )
    None
  }, (setHeroComponent, dispatch, state, address))

  let handleAskSeedQuestion = _ => {
    switch state.question.title {
    | Some(title) if canSubmit => saveCommandToClipboard(title, options)
    | _ => ()
    }
  }

  <AskContext.Provider value={state, dispatch}>
    <div className="flex justify-center items-center h-full">
      <div className=" p-4 flex items-center justify-center w-full">
        <div
          className="relative lg:p-4 w-full h-full  flex flex-col justify-around items-center lg:border-2 lg:border-primary rounded-xl ">
          <div className="p-2 lg:p-4 flex flex-row justify-between items-center w-full">
            <ReactTooltip
              className="z-50 h-fit-content max-w-xs"
              anchorSelect="#create-vote-question"
              closeOnEsc=true
              clickable=true
              content="This will provide greater detail toward the process of asking a question. We will have to explain 3 main things. \n 1. The components of a question (Title, Answers, correct answer, further details). \n 2. Asking a question requires an unused VOTE token.  \n 3. If a vote token is not owned, your question will be turned into a Discord command that you can paste into the questions channel on Discord. "
            />
            <h2 className="text-xl lg:text-2xl text-black opacity-60 ">
              {"Add Options"->React.string}
            </h2>
            <div
              id="create-vote-question"
              type_="button"
              className="flex self-end items-center justify-center text-default-dark lg:text-primary-dark font-bold text-3xl h-10 w-10 hover:scale-125 hover:default transition-all duration-200 ease-linear rounded-full">
              <ReactIcons.LuInfo className="lg:text-default-darker text-default-dark" />
            </div>
          </div>
          <div className="h-full w-full rounded-xl flex justify-start flex-col z-10 pb-4 gap-4">
            <div className="flex flex-row ">
              <AskOptions />
              <div className="text-center pl-4 flex flex-col-reverse">
                <button
                  className="w-4 font-bold font-fugaz text-4xl pb-5 hover:scale-125 transition-all duration-300 ease-linear"
                  type_="button"
                  onClick={handleAddOption}>
                  {{Array.length(options) < maxOptions ? "+" : ""}->React.string}
                </button>
              </div>
            </div>
            <ReactTooltip
              anchorSelect="#copy-discord-command"
              openOnClick=true
              clickable=true
              style={{
                backgroundColor: "transparent",
              }}
            />
            {switch (linkedVote, address->Nullable.toOption) {
            | (Some({question: Some({state: Submitted | Flagged | Approved})}), Some(_)) =>
              <React.Suspense
                fallback={<button
                  disabled={true}
                  className="mb-auto min-w-[8rem] min-h-[3rem] font-bold disabled:bg-default-disabled disabled:text-default-darker disabled:opacity-50 disabled:scale-100 rounded-2xl max-w-xs self-center bg-default-darker lg:bg-active text-white transition-all ease-linear hover:scale-105  ">
                  {"Edit"->React.string}
                </button>}>
                <EditButton canSubmit={canSubmit} />
              </React.Suspense>

            | (Some({question: None}), Some(_)) => <SubmitButton canSubmit={canSubmit} />
            | _ =>
              <button
                onClick=handleAskSeedQuestion
                disabled={!canSubmit}
                className="mb-auto min-w-[8rem] min-h-[3rem] font-bold disabled:bg-default-disabled disabled:text-default-darker disabled:opacity-50 disabled:scale-100 rounded-2xl max-w-xs self-center bg-default-darker lg:bg-active text-white transition-all ease-linear hover:scale-105  ">
                {"Ask"->React.string}
              </button>
            }}
          </div>
        </div>
      </div>
    </div>
  </AskContext.Provider>
}
