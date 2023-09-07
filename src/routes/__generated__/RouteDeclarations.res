
open RelayRouter__Internal__DeclarationsSupport

external unsafe_toPrepareProps: 'any => prepareProps = "%identity"


@val external import__Main: (@as(json`"@rescriptModule/Main_route_renderer"`) _, unit) => promise<RouteRenderer.t> = "import"

@val external import__Main__Auction: (@as(json`"@rescriptModule/Main__Auction_route_renderer"`) _, unit) => promise<RouteRenderer.t> = "import"

@val external import__Main__Auction__Bids: (@as(json`"@rescriptModule/Main__Auction__Bids_route_renderer"`) _, unit) => promise<RouteRenderer.t> = "import"

@val external import__Main__Queue: (@as(json`"@rescriptModule/Main__Queue_route_renderer"`) _, unit) => promise<RouteRenderer.t> = "import"

@val external import__Main__Raffles: (@as(json`"@rescriptModule/Main__Raffles_route_renderer"`) _, unit) => promise<RouteRenderer.t> = "import"

@val external import__Main__Votes: (@as(json`"@rescriptModule/Main__Votes_route_renderer"`) _, unit) => promise<RouteRenderer.t> = "import"

@val external import__Main__Questions: (@as(json`"@rescriptModule/Main__Questions_route_renderer"`) _, unit) => promise<RouteRenderer.t> = "import"

@val external import__FourOhFour: (@as(json`"@rescriptModule/FourOhFour_route_renderer"`) _, unit) => promise<RouteRenderer.t> = "import"

let loadedRouteRenderers: Belt.HashMap.String.t<loadedRouteRenderer> = Belt.HashMap.String.make(
  ~hintSize=8,
)

let make = (~prepareDisposeTimeout=5 * 60 * 1000): array<RelayRouter.Types.route> => {
  let {prepareRoute, getPrepared} = makePrepareAssets(~loadedRouteRenderers, ~prepareDisposeTimeout)

  [
      {
    let routeName = "Main"
    let loadRouteRenderer = () => import__Main->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
    let makePrepareProps = (. 
    ~environment: RescriptRelay.Environment.t,
    ~pathParams: Js.Dict.t<string>,
    ~queryParams: RelayRouter.Bindings.QueryParams.t,
    ~location: RelayRouter.History.location,
  ): prepareProps => {
    ignore(pathParams)
    let prepareProps: Route__Main_route.Internal.prepareProps =   {
      environment: environment,
  
      location: location,
      tokenId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
      linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
    }
    prepareProps->unsafe_toPrepareProps
  }
  
    {
      path: "/",
      name: routeName,
      chunk: "Main_route_renderer",
      loadRouteRenderer,
      preloadCode: (
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
      ) => preloadCode(
        ~loadedRouteRenderers,
        ~routeName,
        ~loadRouteRenderer,
        ~environment,
        ~location,
        ~makePrepareProps,
        ~pathParams,
        ~queryParams,
      ),
      prepare: (
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
        ~intent: RelayRouter.Types.prepareIntent,
      ) => prepareRoute(
        ~environment,
        ~pathParams,
        ~queryParams,
        ~location,
        ~getPrepared,
        ~loadRouteRenderer,
        ~makePrepareProps,
        ~makeRouteKey=(
    ~pathParams: Js.Dict.t<string>,
    ~queryParams: RelayRouter.Bindings.QueryParams.t
  ): string => {
    ignore(pathParams)
  
    "Main:"
  
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.getWithDefault("")
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
  }
  
  ,
        ~routeName,
        ~intent
      ),
      children: [    {
        let routeName = "Main__Auction"
        let loadRouteRenderer = () => import__Main__Auction->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
        let makePrepareProps = (. 
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
      ): prepareProps => {
        ignore(pathParams)
        let prepareProps: Route__Main__Auction_route.Internal.prepareProps =   {
          environment: environment,
      
          location: location,
          tokenId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "",
          name: routeName,
          chunk: "Main__Auction_route_renderer",
          loadRouteRenderer,
          preloadCode: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
          ) => preloadCode(
            ~loadedRouteRenderers,
            ~routeName,
            ~loadRouteRenderer,
            ~environment,
            ~location,
            ~makePrepareProps,
            ~pathParams,
            ~queryParams,
          ),
          prepare: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
            ~intent: RelayRouter.Types.prepareIntent,
          ) => prepareRoute(
            ~environment,
            ~pathParams,
            ~queryParams,
            ~location,
            ~getPrepared,
            ~loadRouteRenderer,
            ~makePrepareProps,
            ~makeRouteKey=(
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t
      ): string => {
        ignore(pathParams)
      
        "Main__Auction:"
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
      }
      
      ,
            ~routeName,
            ~intent
          ),
          children: [      {
              let routeName = "Main__Auction__Bids"
              let loadRouteRenderer = () => import__Main__Auction__Bids->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
              let makePrepareProps = (. 
              ~environment: RescriptRelay.Environment.t,
              ~pathParams: Js.Dict.t<string>,
              ~queryParams: RelayRouter.Bindings.QueryParams.t,
              ~location: RelayRouter.History.location,
            ): prepareProps => {
              ignore(pathParams)
              let prepareProps: Route__Main__Auction__Bids_route.Internal.prepareProps =   {
                environment: environment,
            
                location: location,
                tokenId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
                linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
              }
              prepareProps->unsafe_toPrepareProps
            }
            
              {
                path: "",
                name: routeName,
                chunk: "Main__Auction__Bids_route_renderer",
                loadRouteRenderer,
                preloadCode: (
                  ~environment: RescriptRelay.Environment.t,
                  ~pathParams: Js.Dict.t<string>,
                  ~queryParams: RelayRouter.Bindings.QueryParams.t,
                  ~location: RelayRouter.History.location,
                ) => preloadCode(
                  ~loadedRouteRenderers,
                  ~routeName,
                  ~loadRouteRenderer,
                  ~environment,
                  ~location,
                  ~makePrepareProps,
                  ~pathParams,
                  ~queryParams,
                ),
                prepare: (
                  ~environment: RescriptRelay.Environment.t,
                  ~pathParams: Js.Dict.t<string>,
                  ~queryParams: RelayRouter.Bindings.QueryParams.t,
                  ~location: RelayRouter.History.location,
                  ~intent: RelayRouter.Types.prepareIntent,
                ) => prepareRoute(
                  ~environment,
                  ~pathParams,
                  ~queryParams,
                  ~location,
                  ~getPrepared,
                  ~loadRouteRenderer,
                  ~makePrepareProps,
                  ~makeRouteKey=(
              ~pathParams: Js.Dict.t<string>,
              ~queryParams: RelayRouter.Bindings.QueryParams.t
            ): string => {
              ignore(pathParams)
            
              "Main__Auction__Bids:"
            
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
            }
            
            ,
                  ~routeName,
                  ~intent
                ),
                children: [],
              }
            }],
        }
      },
      {
        let routeName = "Main__Queue"
        let loadRouteRenderer = () => import__Main__Queue->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
        let makePrepareProps = (. 
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
      ): prepareProps => {
        ignore(pathParams)
        let prepareProps: Route__Main__Queue_route.Internal.prepareProps =   {
          environment: environment,
      
          location: location,
          tokenId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "queue",
          name: routeName,
          chunk: "Main__Queue_route_renderer",
          loadRouteRenderer,
          preloadCode: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
          ) => preloadCode(
            ~loadedRouteRenderers,
            ~routeName,
            ~loadRouteRenderer,
            ~environment,
            ~location,
            ~makePrepareProps,
            ~pathParams,
            ~queryParams,
          ),
          prepare: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
            ~intent: RelayRouter.Types.prepareIntent,
          ) => prepareRoute(
            ~environment,
            ~pathParams,
            ~queryParams,
            ~location,
            ~getPrepared,
            ~loadRouteRenderer,
            ~makePrepareProps,
            ~makeRouteKey=(
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t
      ): string => {
        ignore(pathParams)
      
        "Main__Queue:"
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
      }
      
      ,
            ~routeName,
            ~intent
          ),
          children: [],
        }
      },
      {
        let routeName = "Main__Raffles"
        let loadRouteRenderer = () => import__Main__Raffles->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
        let makePrepareProps = (. 
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
      ): prepareProps => {
        ignore(pathParams)
        let prepareProps: Route__Main__Raffles_route.Internal.prepareProps =   {
          environment: environment,
      
          location: location,
          tokenId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "/raffles",
          name: routeName,
          chunk: "Main__Raffles_route_renderer",
          loadRouteRenderer,
          preloadCode: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
          ) => preloadCode(
            ~loadedRouteRenderers,
            ~routeName,
            ~loadRouteRenderer,
            ~environment,
            ~location,
            ~makePrepareProps,
            ~pathParams,
            ~queryParams,
          ),
          prepare: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
            ~intent: RelayRouter.Types.prepareIntent,
          ) => prepareRoute(
            ~environment,
            ~pathParams,
            ~queryParams,
            ~location,
            ~getPrepared,
            ~loadRouteRenderer,
            ~makePrepareProps,
            ~makeRouteKey=(
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t
      ): string => {
        ignore(pathParams)
      
        "Main__Raffles:"
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
      }
      
      ,
            ~routeName,
            ~intent
          ),
          children: [],
        }
      },
      {
        let routeName = "Main__Votes"
        let loadRouteRenderer = () => import__Main__Votes->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
        let makePrepareProps = (. 
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
      ): prepareProps => {
        ignore(pathParams)
        let prepareProps: Route__Main__Votes_route.Internal.prepareProps =   {
          environment: environment,
      
          location: location,
          tokenId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "/votes",
          name: routeName,
          chunk: "Main__Votes_route_renderer",
          loadRouteRenderer,
          preloadCode: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
          ) => preloadCode(
            ~loadedRouteRenderers,
            ~routeName,
            ~loadRouteRenderer,
            ~environment,
            ~location,
            ~makePrepareProps,
            ~pathParams,
            ~queryParams,
          ),
          prepare: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
            ~intent: RelayRouter.Types.prepareIntent,
          ) => prepareRoute(
            ~environment,
            ~pathParams,
            ~queryParams,
            ~location,
            ~getPrepared,
            ~loadRouteRenderer,
            ~makePrepareProps,
            ~makeRouteKey=(
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t
      ): string => {
        ignore(pathParams)
      
        "Main__Votes:"
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
      }
      
      ,
            ~routeName,
            ~intent
          ),
          children: [],
        }
      },
      {
        let routeName = "Main__Questions"
        let loadRouteRenderer = () => import__Main__Questions->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
        let makePrepareProps = (. 
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
      ): prepareProps => {
        ignore(pathParams)
        let prepareProps: Route__Main__Questions_route.Internal.prepareProps =   {
          environment: environment,
      
          location: location,
          tokenId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "/questions",
          name: routeName,
          chunk: "Main__Questions_route_renderer",
          loadRouteRenderer,
          preloadCode: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
          ) => preloadCode(
            ~loadedRouteRenderers,
            ~routeName,
            ~loadRouteRenderer,
            ~environment,
            ~location,
            ~makePrepareProps,
            ~pathParams,
            ~queryParams,
          ),
          prepare: (
            ~environment: RescriptRelay.Environment.t,
            ~pathParams: Js.Dict.t<string>,
            ~queryParams: RelayRouter.Bindings.QueryParams.t,
            ~location: RelayRouter.History.location,
            ~intent: RelayRouter.Types.prepareIntent,
          ) => prepareRoute(
            ~environment,
            ~pathParams,
            ~queryParams,
            ~location,
            ~getPrepared,
            ~loadRouteRenderer,
            ~makePrepareProps,
            ~makeRouteKey=(
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t
      ): string => {
        ignore(pathParams)
      
        "Main__Questions:"
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("tokenId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
      }
      
      ,
            ~routeName,
            ~intent
          ),
          children: [],
        }
      }],
    }
  },
  {
    let routeName = "FourOhFour"
    let loadRouteRenderer = () => import__FourOhFour->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
    let makePrepareProps = (. 
    ~environment: RescriptRelay.Environment.t,
    ~pathParams: Js.Dict.t<string>,
    ~queryParams: RelayRouter.Bindings.QueryParams.t,
    ~location: RelayRouter.History.location,
  ): prepareProps => {
    ignore(pathParams)
    ignore(queryParams)
    let prepareProps: Route__FourOhFour_route.Internal.prepareProps =   {
      environment: environment,
  
      location: location,
    }
    prepareProps->unsafe_toPrepareProps
  }
  
    {
      path: "*",
      name: routeName,
      chunk: "FourOhFour_route_renderer",
      loadRouteRenderer,
      preloadCode: (
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
      ) => preloadCode(
        ~loadedRouteRenderers,
        ~routeName,
        ~loadRouteRenderer,
        ~environment,
        ~location,
        ~makePrepareProps,
        ~pathParams,
        ~queryParams,
      ),
      prepare: (
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
        ~intent: RelayRouter.Types.prepareIntent,
      ) => prepareRoute(
        ~environment,
        ~pathParams,
        ~queryParams,
        ~location,
        ~getPrepared,
        ~loadRouteRenderer,
        ~makePrepareProps,
        ~makeRouteKey=(
    ~pathParams: Js.Dict.t<string>,
    ~queryParams: RelayRouter.Bindings.QueryParams.t
  ): string => {
    ignore(pathParams)
    ignore(queryParams)
  
    "FourOhFour:"
  
  
  }
  
  ,
        ~routeName,
        ~intent
      ),
      children: [],
    }
  }
  ]
}