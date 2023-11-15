
open RelayRouter__Internal__DeclarationsSupport

external unsafe_toPrepareProps: 'any => prepareProps = "%identity"

let loadedRouteRenderers: Belt.HashMap.String.t<loadedRouteRenderer> = Belt.HashMap.String.make(
  ~hintSize=13,
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
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
      }
      
      ,
            ~routeName,
            ~intent
          ),
          children: [      {
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
        let routeName = "Main__Question"
        let loadRouteRenderer = () => (() => Js.import(Main__Question_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
        let makePrepareProps = (. 
        ~environment: RescriptRelay.Environment.t,
        ~pathParams: Js.Dict.t<string>,
        ~queryParams: RelayRouter.Bindings.QueryParams.t,
        ~location: RelayRouter.History.location,
      ): prepareProps => {
        ignore(pathParams)
        let prepareProps: Route__Main__Question_route.Internal.prepareProps =   {
          environment: environment,
      
          location: location,
          linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          answer: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
        }
        prepareProps->unsafe_toPrepareProps
      }
      
        {
          path: "question",
          name: routeName,
          chunk: "Main__Question_route_renderer",
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
      
        "Main__Question:"
      
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.getWithDefault("")
      }
      
      ,
            ~routeName,
            ~intent
          ),
          children: [      {
              let routeName = "Main__Question__Ask"
              let loadRouteRenderer = () => (() => Js.import(Main__Question__Ask_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
              let makePrepareProps = (. 
              ~environment: RescriptRelay.Environment.t,
              ~pathParams: Js.Dict.t<string>,
              ~queryParams: RelayRouter.Bindings.QueryParams.t,
              ~location: RelayRouter.History.location,
            ): prepareProps => {
              ignore(pathParams)
              let prepareProps: Route__Main__Question__Ask_route.Internal.prepareProps =   {
                environment: environment,
            
                location: location,
                linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                answer: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
              }
              prepareProps->unsafe_toPrepareProps
            }
            
              {
                path: "ask",
                name: routeName,
                chunk: "Main__Question__Ask_route_renderer",
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
            
              "Main__Question__Ask:"
            
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.getWithDefault("")
            }
            
            ,
                  ~routeName,
                  ~intent
                ),
                children: [        {
                      let routeName = "Main__Question__Ask__UseVote"
                      let loadRouteRenderer = () => (() => Js.import(Main__Question__Ask__UseVote_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
                      let makePrepareProps = (. 
                      ~environment: RescriptRelay.Environment.t,
                      ~pathParams: Js.Dict.t<string>,
                      ~queryParams: RelayRouter.Bindings.QueryParams.t,
                      ~location: RelayRouter.History.location,
                    ): prepareProps => {
                      ignore(pathParams)
                      let prepareProps: Route__Main__Question__Ask__UseVote_route.Internal.prepareProps =   {
                        environment: environment,
                    
                        location: location,
                        linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                        voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                        voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                        showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                        answer: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                      }
                      prepareProps->unsafe_toPrepareProps
                    }
                    
                      {
                        path: "",
                        name: routeName,
                        chunk: "Main__Question__Ask__UseVote_route_renderer",
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
                    
                      "Main__Question__Ask__UseVote:"
                    
                        ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
                        ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
                        ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
                        ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
                        ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.getWithDefault("")
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
              let routeName = "Main__Question__Current"
              let loadRouteRenderer = () => (() => Js.import(Main__Question__Current_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
              let makePrepareProps = (. 
              ~environment: RescriptRelay.Environment.t,
              ~pathParams: Js.Dict.t<string>,
              ~queryParams: RelayRouter.Bindings.QueryParams.t,
              ~location: RelayRouter.History.location,
            ): prepareProps => {
              ignore(pathParams)
              let prepareProps: Route__Main__Question__Current_route.Internal.prepareProps =   {
                environment: environment,
            
                location: location,
                linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                answer: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                id: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("id")->Belt.Option.flatMap(value => Some(value->Js.Global.decodeURIComponent)),
              }
              prepareProps->unsafe_toPrepareProps
            }
            
              {
                path: "",
                name: routeName,
                chunk: "Main__Question__Current_route_renderer",
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
            
              "Main__Question__Current:"
            
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("id")->Belt.Option.getWithDefault("")
            }
            
            ,
                  ~routeName,
                  ~intent
                ),
                children: [],
              }
            },
            {
              let routeName = "Main__Question__Past"
              let loadRouteRenderer = () => (() => Js.import(Main__Question__Past_route_renderer.renderer))->Obj.magic->doLoadRouteRenderer(~routeName, ~loadedRouteRenderers)
              let makePrepareProps = (. 
              ~environment: RescriptRelay.Environment.t,
              ~pathParams: Js.Dict.t<string>,
              ~queryParams: RelayRouter.Bindings.QueryParams.t,
              ~location: RelayRouter.History.location,
            ): prepareProps => {
              let prepareProps: Route__Main__Question__Past_route.Internal.prepareProps =   {
                environment: environment,
            
                location: location,
                questionId: pathParams->Js.Dict.unsafeGet("questionId"),
                linkBrightID: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
                answer: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
              }
              prepareProps->unsafe_toPrepareProps
            }
            
              {
                path: ":questionId",
                name: routeName,
                chunk: "Main__Question__Past_route_renderer",
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
            
              "Main__Question__Past:"
                ++ pathParams->Js.Dict.get("questionId")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("linkBrightID")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
                ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("answer")->Belt.Option.getWithDefault("")
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
          voteDetails: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          voteDetailsToken: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          showAllBids: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.flatMap(value => Belt.Int.fromString(value)),
          sortBy: queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("sortBy")->Belt.Option.flatMap(value => value->Js.Global.decodeURIComponent->VotesSortBy.parse),
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
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetails")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("voteDetailsToken")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("showAllBids")->Belt.Option.getWithDefault("")
          ++ queryParams->RelayRouter.Bindings.QueryParams.getParamByKey("sortBy")->Belt.Option.getWithDefault("")
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