// @generated
// This file is autogenerated from `routes.json`, do not edit manually.
module Internal = {
  @live
  type prepareProps = {
    environment: RescriptRelay.Environment.t,
    location: RelayRouter.History.location,
    tokenId: option<string>,
  }

  @live
  type renderProps<'prepared> = {
    childRoutes: React.element,
    prepared: 'prepared,
    environment: RescriptRelay.Environment.t,
    location: RelayRouter.History.location,
    tokenId: option<string>,
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
      tokenId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
    }
  }

}

type queryParams = {
  tokenId: option<string>,
}

@live
let parseQueryParams = (search: string): queryParams => {
  open RelayRouter.Bindings
  let queryParams = QueryParams.parse(search)
  {
    tokenId: queryParams->QueryParams.getParamByKey("tokenId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),

  }
}

@live
let makeQueryParams = (
  ~tokenId: option<string>=?, 
  ()
) => {
  tokenId: tokenId,
}

@live
let applyQueryParams = (
  queryParams: RelayRouter__Bindings.QueryParams.t,
  ~newParams: queryParams,
) => {
  open RelayRouter__Bindings

  
  queryParams->QueryParams.setParamOpt(~key="tokenId", ~value=newParams.tokenId->Belt.Option.map(tokenId => tokenId->Js.Global.encodeURIComponent))
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
let routePattern = "/"

@live
let makeLink = (~tokenId: option<string>=?) => {
  open RelayRouter.Bindings
  let queryParams = QueryParams.make()
  switch tokenId {
    | None => ()
    | Some(tokenId) => queryParams->QueryParams.setParam(~key="tokenId", ~value=tokenId->Js.Global.encodeURIComponent)
  }
  RelayRouter.Bindings.generatePath(routePattern, Js.Dict.fromArray([])) ++ queryParams->QueryParams.toString
}
@live
let makeLinkFromQueryParams = (queryParams: queryParams) => {
  makeLink(~tokenId=?queryParams.tokenId, )
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