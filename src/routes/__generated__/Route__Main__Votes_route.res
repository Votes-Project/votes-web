// @generated
// This file is autogenerated from `routes.json`, do not edit manually.
module Internal = {
  @live
  type prepareProps = {
    environment: RescriptRelay.Environment.t,
    location: RelayRouter.History.location,
    linkBrightID: option<int>,
    contextId: option<string>,
    voteDetails: option<int>,
    voteDetailsToken: option<int>,
    showAllBids: option<int>,
    sortBy: option<VotesSortBy.t>,
    address: option<string>,
  }

  @live
  type renderProps<'prepared> = {
    childRoutes: React.element,
    prepared: 'prepared,
    environment: RescriptRelay.Environment.t,
    location: RelayRouter.History.location,
    linkBrightID: option<int>,
    contextId: option<string>,
    voteDetails: option<int>,
    voteDetailsToken: option<int>,
    showAllBids: option<int>,
    sortBy: option<VotesSortBy.t>,
    address: option<string>,
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
      contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
      voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      sortBy: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("sortBy")->Belt.Option.flatMap(value => value->Js.Global.decodeURIComponent->VotesSortBy.parse),
      address: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("address")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
    }
  }

}

type queryParams = {
  linkBrightID: option<int>,
  contextId: option<string>,
  voteDetails: option<int>,
  voteDetailsToken: option<int>,
  showAllBids: option<int>,
  sortBy: option<VotesSortBy.t>,
  address: option<string>,
}

@live
let parseQueryParams = (search: string): queryParams => {
  open RelayRouter.Bindings
  let queryParams = QueryParams.parse(search)
  {
    linkBrightID: queryParams->QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    contextId: queryParams->QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),

    voteDetails: queryParams->QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    voteDetailsToken: queryParams->QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    showAllBids: queryParams->QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),

    sortBy: queryParams->QueryParams.getParamByKey("sortBy")->Belt.Option.flatMap(value => value->Js.Global.decodeURIComponent->VotesSortBy.parse),

    address: queryParams->QueryParams.getParamByKey("address")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),

  }
}

@live
let makeQueryParams = (
  ~linkBrightID: option<int>=?, 
  ~contextId: option<string>=?, 
  ~voteDetails: option<int>=?, 
  ~voteDetailsToken: option<int>=?, 
  ~showAllBids: option<int>=?, 
  ~sortBy: option<VotesSortBy.t>=?, 
  ~address: option<string>=?, 
  ()
) => {
  linkBrightID: linkBrightID,
  contextId: contextId,
  voteDetails: voteDetails,
  voteDetailsToken: voteDetailsToken,
  showAllBids: showAllBids,
  sortBy: sortBy,
  address: address,
}

@live
let applyQueryParams = (
  queryParams: RelayRouter__Bindings.QueryParams.t,
  ~newParams: queryParams,
) => {
  open RelayRouter__Bindings

  
  queryParams->QueryParams.setParamOpt(~key="linkBrightID", ~value=newParams.linkBrightID->Belt.Option.map(linkBrightID => Belt.Int.toString(linkBrightID)))
  queryParams->QueryParams.setParamOpt(~key="contextId", ~value=newParams.contextId->Belt.Option.map(contextId => contextId->Js.Global.encodeURIComponent))
  queryParams->QueryParams.setParamOpt(~key="voteDetails", ~value=newParams.voteDetails->Belt.Option.map(voteDetails => Belt.Int.toString(voteDetails)))
  queryParams->QueryParams.setParamOpt(~key="voteDetailsToken", ~value=newParams.voteDetailsToken->Belt.Option.map(voteDetailsToken => Belt.Int.toString(voteDetailsToken)))
  queryParams->QueryParams.setParamOpt(~key="showAllBids", ~value=newParams.showAllBids->Belt.Option.map(showAllBids => Belt.Int.toString(showAllBids)))
  queryParams->QueryParams.setParamOpt(~key="sortBy", ~value=newParams.sortBy->Belt.Option.map(sortBy => sortBy->VotesSortBy.serialize->Js.Global.encodeURIComponent))
  queryParams->QueryParams.setParamOpt(~key="address", ~value=newParams.address->Belt.Option.map(address => address->Js.Global.encodeURIComponent))
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
let routePattern = "/votes"

@live
let makeLink = (~linkBrightID: option<int>=?, ~contextId: option<string>=?, ~voteDetails: option<int>=?, ~voteDetailsToken: option<int>=?, ~showAllBids: option<int>=?, ~sortBy: option<VotesSortBy.t>=?, ~address: option<string>=?) => {
  open RelayRouter.Bindings
  let queryParams = QueryParams.make()
  switch linkBrightID {
    | None => ()
    | Some(linkBrightID) => queryParams->QueryParams.setParam(~key="linkBrightID", ~value=Belt.Int.toString(linkBrightID))
  }

  switch contextId {
    | None => ()
    | Some(contextId) => queryParams->QueryParams.setParam(~key="contextId", ~value=contextId->Js.Global.encodeURIComponent)
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

  switch sortBy {
    | None => ()
    | Some(sortBy) => queryParams->QueryParams.setParam(~key="sortBy", ~value=sortBy->VotesSortBy.serialize->Js.Global.encodeURIComponent)
  }

  switch address {
    | None => ()
    | Some(address) => queryParams->QueryParams.setParam(~key="address", ~value=address->Js.Global.encodeURIComponent)
  }
  RelayRouter.Bindings.generatePath(routePattern, Js.Dict.fromArray([])) ++ queryParams->QueryParams.toString
}
@live
let makeLinkFromQueryParams = (queryParams: queryParams) => {
  makeLink(~linkBrightID=?queryParams.linkBrightID, ~contextId=?queryParams.contextId, ~voteDetails=?queryParams.voteDetails, ~voteDetailsToken=?queryParams.voteDetailsToken, ~showAllBids=?queryParams.showAllBids, ~sortBy=?queryParams.sortBy, ~address=?queryParams.address, )
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