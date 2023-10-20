
open RelayRouter__Internal__DeclarationsSupport

external unsafe_toPrepareProps: 'any => prepareProps = "%identity"

let loadedRouteRenderers: Belt.HashMap.String.t<loadedRouteRenderer> = Belt.HashMap.String.make(
  ~hintSize=9,
)

let make = (~prepareDisposeTimeout=5 * 60 * 1000): array<RelayRouter.Types.route> => {
  let {prepareRoute, getPrepared} = makePrepareAssets(~loadedRouteRenderers, ~prepareDisposeTimeout)

  [
      {
    let routeName = "Main"
    let loadRouteRenderer = () => (() => Js.import(Main_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
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
      linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
      voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
      showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
    }
    prepareProps->unsafe_toPrepareProps
  }
  
    {
      path: "",
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
  
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
      ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
  }
  
  ,
        ~routeName,
        ~intent
      ),
      children: [    {
        let routeName = "Main__Vote"
        let loadRouteRenderer = () => (() => Js.import(Main__Vote_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
        let makePrepareProps = (. 
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
      ): prepareProps => {
        ignore(pathParams)
        let prepareProps: Route__Main__Vote_route.Internal.prepareProps =   {
          environment: environment,
      
          location: location,
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "vote",
          name: routeName,
          chunk: "Main__Vote_route_renderer",
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
      
        "Main__Vote:"
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
      }
      
      ,
            ~routeName,
            ~intent
          ),
          children: [      {
              let routeName = "Main__Vote__New"
              let loadRouteRenderer = () => (() => Js.import(Main__Vote__New_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
              let makePrepareProps = (. 
              ~environment: RescriptRelay.Environment.t,
              ~pathParams: Js.Dict.t<string>,
              ~queryParams: RelayRouter.Bindings.QueryParams.t,
              ~location: RelayRouter.History.location,
            ): prepareProps => {
              ignore(pathParams)
              let prepareProps: Route__Main__Vote__New_route.Internal.prepareProps =   {
                environment: environment,
            
                location: location,
                linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
                voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
              }
              prepareProps->unsafe_toPrepareProps
            }
            
              {
                path: "new",
                name: routeName,
                chunk: "Main__Vote__New_route_renderer",
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
            
              "Main__Vote__New:"
            
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
            }
            
            ,
                  ~routeName,
                  ~intent
                ),
                children: [],
              }
            },
            {
              let routeName = "Main__Vote__Auction"
              let loadRouteRenderer = () => (() => Js.import(Main__Vote__Auction_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
              let makePrepareProps = (. 
              ~environment: RescriptRelay.Environment.t,
              ~pathParams: Js.Dict.t<string>,
              ~queryParams: RelayRouter.Bindings.QueryParams.t,
              ~location: RelayRouter.History.location,
            ): prepareProps => {
              let prepareProps: Route__Main__Vote__Auction_route.Internal.prepareProps =   {
                environment: environment,
            
                location: location,
                tokenId: pathParams->Js.Dict.unsafeGet("tokenId"),
                linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
                voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
              }
              prepareProps->unsafe_toPrepareProps
            }
            
              {
                path: ":tokenId",
                name: routeName,
                chunk: "Main__Vote__Auction_route_renderer",
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
            
              "Main__Vote__Auction:"
                ++ pathParams->Js.Dict.get("tokenId")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
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
        let loadRouteRenderer = () => (() => Js.import(Main__Queue_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
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
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
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
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
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
        let loadRouteRenderer = () => (() => Js.import(Main__Raffles_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
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
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "raffles",
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
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
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
        let loadRouteRenderer = () => (() => Js.import(Main__Votes_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
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
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          sortBy: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("sortBy")->Belt.Option.flatMap(value => value->Js.Global.decodeURIComponent->VotesSortBy.parse),
          address: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("address")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "votes",
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
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("sortBy")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("address")->Belt.Option.getWithDefault("")
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
        let loadRouteRenderer = () => (() => Js.import(Main__Questions_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
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
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          dailyQuestion: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          contextId: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
          voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "questions",
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
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("dailyQuestion")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("contextId")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
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
    let loadRouteRenderer = () => (() => Js.import(FourOhFour_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
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