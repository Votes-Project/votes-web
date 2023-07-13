@val @scope(("import", "meta", "env"))
external publicUrl: option<string> = "VITE_PUBLIC_URL"

@val @scope(("import", "meta", "env"))
external port: option<string> = "PORT"

let localhost = `http://localhost:${port->Option.getWithDefault("3000")}`
// This is a simple example of how one could leverage `preloadAsset` to preload
// things from the GraphQL response. This should live inside of the
// (comprehensive) example application we're going to build eventually.
@modu
let preloadFromResponse = (part: Js.Json.t, ~preloadAsset: RelayRouter__Types.preloadAssetFn) => {
  switch part->Js.Json.decodeObject {
  | None => ()
  | Some(obj) =>
    switch obj->Dict.get("extensions") {
    | None => ()
    | Some(extensions) =>
      switch extensions->Js.Json.decodeObject {
      | None => ()
      | Some(extensions) =>
        extensions
        ->Dict.get("preloadableImages")
        ->Option.map(images =>
          images
          ->Js.Json.decodeArray
          ->Option.getWithDefault([])
          ->Array.filterMap(item => item->Js.Json.decodeString)
        )
        ->Option.getWithDefault([])
        ->Array.forEach(imgUrl => {
          preloadAsset(~priority=RelayRouter.Types.Default, RelayRouter.Types.Image({url: imgUrl}))
        })
      }
    }
  }
}

//  Boilerplate for Client and Server fetch functions
let makeFetchQuery = (~preloadAsset) =>
  RelaySSRUtils.makeClientFetchFunction((sink, operation, variables, _cacheConfig, _uploads) => {
    open RelayRouter.NetworkUtils
    let baseUrl = publicUrl->Option.getWithDefault(localhost)
    fetch(
      `${baseUrl}/api/graphql`,
      {
        "method": "POST",
        "headers": Js.Dict.fromArray([("content-type", "application/json")]),
        "body": {"query": operation.text, "variables": variables}
        ->Js.Json.stringifyAny
        ->Option.getWithDefault(""),
      },
    )
    ->Promise.thenResolve(r => {
      r->getChunks(
        ~onNext=part => {
          part->preloadFromResponse(~preloadAsset)
          sink.next(part)
        },
        ~onError=err => {
          sink.error(err)
        },
        ~onComplete=() => {
          sink.complete()
        },
      )
    })
    ->ignore

    None
  })

let makeServerFetchQuery = (
  ~onQuery,
  ~preloadAsset,
): RescriptRelay.Network.fetchFunctionObservable => {
  RelaySSRUtils.makeServerFetchFunction(onQuery, (
    sink,
    operation,
    variables,
    _cacheConfig,
    _uploads,
  ) => {
    open RelayRouter.NetworkUtils
    let baseUrl = publicUrl->Option.getWithDefault(localhost)
    fetchServer(
      `${baseUrl}/api/graphql`,
      {
        "method": "POST",
        "headers": Js.Dict.fromArray([("content-type", "application/json")]),
        "body": {"query": operation.text, "variables": variables}
        ->Js.Json.stringifyAny
        ->Option.getWithDefault(""),
      },
    )
    ->Promise.thenResolve(r => {
      r->getChunks(
        ~onNext=part => {
          part->preloadFromResponse(~preloadAsset)
          sink.next(part)
        },
        ~onError=err => {
          sink.error(err)
        },
        ~onComplete=() => {
          sink.complete()
        },
      )
    })
    ->ignore

    None
  })
}
