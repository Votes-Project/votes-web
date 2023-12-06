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
    day: option<QuestionDay.t>,
    calendar: option<CalendarType.t>,
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
    day: option<QuestionDay.t>,
    calendar: option<CalendarType.t>,
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
      day: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("day")->Belt.Option.flatMap(value => value->Js.Global.decodeURIComponent->QuestionDay.parse),
      calendar: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("calendar")->Belt.Option.flatMap(value => value->Js.Global.decodeURIComponent->CalendarType.parse),
    }
  }

}

type queryParams = {
  linkBrightID: option<int>,
  voteDetails: option<int>,
  voteDetailsToken: option<int>,
  showAllBids: option<int>,
  day: option<QuestionDay.t>,
  calendar: option<CalendarType.t>,
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

    day: queryParams->QueryParams.getParamByKey("day")->Belt.Option.flatMap(value => value->Js.Global.decodeURIComponent->QuestionDay.parse),

    calendar: queryParams->QueryParams.getParamByKey("calendar")->Belt.Option.flatMap(value => value->Js.Global.decodeURIComponent->CalendarType.parse),

  }
}

@live
let makeQueryParams = (
  ~linkBrightID: option<int>=?, 
  ~voteDetails: option<int>=?, 
  ~voteDetailsToken: option<int>=?, 
  ~showAllBids: option<int>=?, 
  ~day: option<QuestionDay.t>=?, 
  ~calendar: option<CalendarType.t>=?, 
  ()
) => {
  linkBrightID: linkBrightID,
  voteDetails: voteDetails,
  voteDetailsToken: voteDetailsToken,
  showAllBids: showAllBids,
  day: day,
  calendar: calendar,
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
  queryParams->QueryParams.setParamOpt(~key="day", ~value=newParams.day->Belt.Option.map(day => day->QuestionDay.serialize->Js.Global.encodeURIComponent))
  queryParams->QueryParams.setParamOpt(~key="calendar", ~value=newParams.calendar->Belt.Option.map(calendar => calendar->CalendarType.serialize->Js.Global.encodeURIComponent))
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
let routePattern = "/questions"

@live
let makeLink = (~linkBrightID: option<int>=?, ~voteDetails: option<int>=?, ~voteDetailsToken: option<int>=?, ~showAllBids: option<int>=?, ~day: option<QuestionDay.t>=?, ~calendar: option<CalendarType.t>=?) => {
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

  switch day {
    | None => ()
    | Some(day) => queryParams->QueryParams.setParam(~key="day", ~value=day->QuestionDay.serialize->Js.Global.encodeURIComponent)
  }

  switch calendar {
    | None => ()
    | Some(calendar) => queryParams->QueryParams.setParam(~key="calendar", ~value=calendar->CalendarType.serialize->Js.Global.encodeURIComponent)
  }
  RelayRouter.Bindings.generatePath(routePattern, Js.Dict.fromArray([])) ++ queryParams->QueryParams.toString
}
@live
let makeLinkFromQueryParams = (queryParams: queryParams) => {
  makeLink(~linkBrightID=?queryParams.linkBrightID, ~voteDetails=?queryParams.voteDetails, ~voteDetailsToken=?queryParams.voteDetailsToken, ~showAllBids=?queryParams.showAllBids, ~day=?queryParams.day, ~calendar=?queryParams.calendar, )
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