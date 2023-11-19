// @generated
// This file is autogenerated from `routes.json`, do not edit manually.
module Internal = {
  @live
  type prepareProps = {
    environment: RescriptRelay.Environment.t,
    location: RelayRouter.History.location,
    linkBrightID: option<int>,
    voteDetails: option<int>,
    voteDetailsToken: option<int>,
    showAllBids: option<int>,
    stats: option<int>,
    answer: option<int>,
    useVote: option<int>,
    question: option<string>,
  }

  @live
  type renderProps<'prepared> = {
    childRoutes: React.element,
    prepared: 'prepared,
    environment: RescriptRelay.Environment.t,
    location: RelayRouter.History.location,
    linkBrightID: option<int>,
    voteDetails: option<int>,
    voteDetailsToken: option<int>,
    showAllBids: option<int>,
    stats: option<int>,
    answer: option<int>,
    useVote: option<int>,
    question: option<string>,
  }

  @live
  type renderers<'prepared> = {
    prepare: prepareProps => 'prepared,
    prepareCode: option<(. prepareProps) => array<RelayRouter.Types.preloadAsset>>,
    render: renderProps<'prepared> => React.element,
  }
  @live
  let makePrepareProps = (. 
    ~environment: RescriptRelay.Environment.t,
    ~pathParams: Js.Dict.t<string>,
    ~queryParams: RelayRouter.Bindings.QueryParams.t,
    ~location: RelayRouter.History.location,
  ): prepareProps => {
    ignore(pathParams)
    {
      environment: environment,
  
      location: location,
      linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      stats: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("stats")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      answer: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      useVote: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("useVote")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      question: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("question")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
    }
  }

}

type queryParams = {
  linkBrightID: option<int>,
  voteDetails: option<int>,
  voteDetailsToken: option<int>,
  showAllBids: option<int>,
  stats: option<int>,
  answer: option<int>,
  useVote: option<int>,
  question: option<string>,
}

@live
let parseQueryParams = (search: string): queryParams => {
  open RelayRouter.Bindings
  let queryParams = QueryParams.parse(search)
  {
    linkBrightID: queryParams->QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    voteDetails: queryParams->QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    voteDetailsToken: queryParams->QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    showAllBids: queryParams->QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    stats: queryParams->QueryParams.getParamByKey("stats")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    answer: queryParams->QueryParams.getParamByKey("answer")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    useVote: queryParams->QueryParams.getParamByKey("useVote")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    question: queryParams->QueryParams.getParamByKey("question")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),

  }
}

@live
let makeQueryParams = (
  ~linkBrightID: option<int>=?, 
  ~voteDetails: option<int>=?, 
  ~voteDetailsToken: option<int>=?, 
  ~showAllBids: option<int>=?, 
  ~stats: option<int>=?, 
  ~answer: option<int>=?, 
  ~useVote: option<int>=?, 
  ~question: option<string>=?, 
  ()
) => {
  linkBrightID: linkBrightID,
  voteDetails: voteDetails,
  voteDetailsToken: voteDetailsToken,
  showAllBids: showAllBids,
  stats: stats,
  answer: answer,
  useVote: useVote,
  question: question,
}

@live
let applyQueryParams = (
  queryParams: RelayRouter__Bindings.QueryParams.t,
  ~newParams: queryParams,
) => {
  open RelayRouter__Bindings

  
  queryParams->QueryParams.setParamOpt(~key="linkBrightID", ~value=newParams.linkBrightID->Belt.Option.map(linkBrightID => Belt.Int.toString(linkBrightID)))
  queryParams->QueryParams.setParamOpt(~key="voteDetails", ~value=newParams.voteDetails->Belt.Option.map(voteDetails => Belt.Int.toString(voteDetails)))
  queryParams->QueryParams.setParamOpt(~key="voteDetailsToken", ~value=newParams.voteDetailsToken->Belt.Option.map(voteDetailsToken => Belt.Int.toString(voteDetailsToken)))
  queryParams->QueryParams.setParamOpt(~key="showAllBids", ~value=newParams.showAllBids->Belt.Option.map(showAllBids => Belt.Int.toString(showAllBids)))
  queryParams->QueryParams.setParamOpt(~key="stats", ~value=newParams.stats->Belt.Option.map(stats => Belt.Int.toString(stats)))
  queryParams->QueryParams.setParamOpt(~key="answer", ~value=newParams.answer->Belt.Option.map(answer => Belt.Int.toString(answer)))
  queryParams->QueryParams.setParamOpt(~key="useVote", ~value=newParams.useVote->Belt.Option.map(useVote => Belt.Int.toString(useVote)))
  queryParams->QueryParams.setParamOpt(~key="question", ~value=newParams.question->Belt.Option.map(question => question->Js.Global.encodeURIComponent))
}

@live
type useQueryParamsReturn = {
  queryParams: queryParams,
  setParams: (
    ~setter: queryParams => queryParams,
    ~onAfterParamsSet: queryParams => unit=?,
    ~navigationMode_: RelayRouter.Types.setQueryParamsMode=?,
    ~removeNotControlledParams: bool=?,
    ~shallow: bool=?,
  ) => unit
}

@live
let useQueryParams = (): useQueryParamsReturn => {
  let internalSetQueryParams = RelayRouter__Internal.useSetQueryParams()
  let {search} = RelayRouter.Utils.useLocation()
  let currentQueryParams = React.useMemo1(() => {
    search->parseQueryParams
  }, [search])

  let setParams = (
    ~setter,
    ~onAfterParamsSet=?,
    ~navigationMode_=RelayRouter.Types.Push,
    ~removeNotControlledParams=true,
    ~shallow=true,
  ) => {
    let newParams = setter(currentQueryParams)

    switch onAfterParamsSet {
    | None => ()
    | Some(onAfterParamsSet) => onAfterParamsSet(newParams)
    }

    internalSetQueryParams({
      applyQueryParams: applyQueryParams(~newParams, ...),
      currentSearch: search,
      navigationMode_: navigationMode_,
      removeNotControlledParams: removeNotControlledParams,
      shallow: shallow,
    })
  }

  {
    queryParams: currentQueryParams,
    setParams: React.useMemo2(
      () => setParams,
      (search, currentQueryParams),
    ),
  }
}

@inline
let routePattern = "/question/ask"

@live
let makeLink = (~linkBrightID: option<int>=?, ~voteDetails: option<int>=?, ~voteDetailsToken: option<int>=?, ~showAllBids: option<int>=?, ~stats: option<int>=?, ~answer: option<int>=?, ~useVote: option<int>=?, ~question: option<string>=?) => {
  open RelayRouter.Bindings
  let queryParams = QueryParams.make()
  switch linkBrightID {
    | None => ()
    | Some(linkBrightID) => queryParams->QueryParams.setParam(~key="linkBrightID", ~value=Belt.Int.toString(linkBrightID))
  }

  switch voteDetails {
    | None => ()
    | Some(voteDetails) => queryParams->QueryParams.setParam(~key="voteDetails", ~value=Belt.Int.toString(voteDetails))
  }

  switch voteDetailsToken {
    | None => ()
    | Some(voteDetailsToken) => queryParams->QueryParams.setParam(~key="voteDetailsToken", ~value=Belt.Int.toString(voteDetailsToken))
  }

  switch showAllBids {
    | None => ()
    | Some(showAllBids) => queryParams->QueryParams.setParam(~key="showAllBids", ~value=Belt.Int.toString(showAllBids))
  }

  switch stats {
    | None => ()
    | Some(stats) => queryParams->QueryParams.setParam(~key="stats", ~value=Belt.Int.toString(stats))
  }

  switch answer {
    | None => ()
    | Some(answer) => queryParams->QueryParams.setParam(~key="answer", ~value=Belt.Int.toString(answer))
  }

  switch useVote {
    | None => ()
    | Some(useVote) => queryParams->QueryParams.setParam(~key="useVote", ~value=Belt.Int.toString(useVote))
  }

  switch question {
    | None => ()
    | Some(question) => queryParams->QueryParams.setParam(~key="question", ~value=question->Js.Global.encodeURIComponent)
  }
  RelayRouter.Bindings.generatePath(routePattern, Js.Dict.fromArray([])) ++ queryParams->QueryParams.toString
}
@live
let makeLinkFromQueryParams = (queryParams: queryParams) => {
  makeLink(~linkBrightID=?queryParams.linkBrightID, ~voteDetails=?queryParams.voteDetails, ~voteDetailsToken=?queryParams.voteDetailsToken, ~showAllBids=?queryParams.showAllBids, ~stats=?queryParams.stats, ~answer=?queryParams.answer, ~useVote=?queryParams.useVote, ~question=?queryParams.question, )
}

@live
let useMakeLinkWithPreservedPath = () => {
  let location = RelayRouter.Utils.useLocation()
  React.useMemo1(() => {
    (makeNewQueryParams: queryParams => queryParams) => {
      let newQueryParams = location.search->parseQueryParams->makeNewQueryParams
      open RelayRouter.Bindings
      let queryParams = location.search->QueryParams.parse
      queryParams->applyQueryParams(~newParams=newQueryParams)
      location.pathname ++ queryParams->QueryParams.toString
    }
  }, [location.search])
}


@live
let isRouteActive = (~exact: bool=false, {pathname}: RelayRouter.History.location): bool => {
  RelayRouter.Internal.matchPathWithOptions({"path": routePattern, "end": exact}, pathname)->Belt.Option.isSome
}

@live
let useIsRouteActive = (~exact=false) => {
  let location = RelayRouter.Utils.useLocation()
  React.useMemo2(() => location->isRouteActive(~exact), (location, exact))
}

@obj
external makeRenderer: (
  ~prepare: Internal.prepareProps => 'prepared,
  ~prepareCode: Internal.prepareProps => array<RelayRouter.Types.preloadAsset>=?,
  ~render: Internal.renderProps<'prepared> => React.element,
) => Internal.renderers<'prepared> = ""