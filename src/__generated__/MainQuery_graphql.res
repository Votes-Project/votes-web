/* @sourceLoc Main.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_auctionCreateds_edges_node = {
    @live id: string,
    tokenId: string,
  }
  and response_auctionCreateds_edges = {
    node: option<response_auctionCreateds_edges_node>,
  }
  and response_auctionCreateds = {
    edges: option<array<option<response_auctionCreateds_edges>>>,
  }
  type response = {
    auctionCreateds: option<response_auctionCreateds>,
  }
  @live
  type rawResponse = response
  @live
  type variables = unit
  @live
  type refetchVariables = unit
  @live let makeRefetchVariables = () => ()
}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let wrapResponseConverterMap = ()
  @live
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    Js.null
  )
  @live
  type responseRaw
  @live
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
}

type queryRef

@live
@inline
let connectionKey = "Main_auctionCreateds_auctionCreateds"

%%private(
  @live @module("relay-runtime") @scope("ConnectionHandler")
  external internal_makeConnectionId: (RescriptRelay.dataId, @as("Main_auctionCreateds_auctionCreateds") _, 'arguments) => RescriptRelay.dataId = "getConnectionID"
)

@live
let makeConnectionId = (connectionParentDataId: RescriptRelay.dataId, ) => {
  let args = {"orderBy": Some("tokenId"), "orderDirection": Some("desc")}
  internal_makeConnectionId(connectionParentDataId, args)
}
module Utils = {
  @@warning("-33")
  open Types

}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "kind": "Literal",
  "name": "orderBy",
  "value": "tokenId"
},
v1 = {
  "kind": "Literal",
  "name": "orderDirection",
  "value": "desc"
},
v2 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "AuctionCreatedEdge",
    "kind": "LinkedField",
    "name": "edges",
    "plural": true,
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "AuctionCreated",
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "id",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "tokenId",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "__typename",
            "storageKey": null
          }
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "cursor",
        "storageKey": null
      }
    ],
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "concreteType": "PageInfo",
    "kind": "LinkedField",
    "name": "pageInfo",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "endCursor",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "hasNextPage",
        "storageKey": null
      }
    ],
    "storageKey": null
  }
],
v3 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 1
  },
  (v0/*: any*/),
  (v1/*: any*/)
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "MainQuery",
    "selections": [
      {
        "alias": "auctionCreateds",
        "args": [
          (v0/*: any*/),
          (v1/*: any*/)
        ],
        "concreteType": "AuctionCreatedConnection",
        "kind": "LinkedField",
        "name": "__Main_auctionCreateds_auctionCreateds_connection",
        "plural": false,
        "selections": (v2/*: any*/),
        "storageKey": "__Main_auctionCreateds_auctionCreateds_connection(orderBy:\"tokenId\",orderDirection:\"desc\")"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "MainQuery",
    "selections": [
      {
        "alias": null,
        "args": (v3/*: any*/),
        "concreteType": "AuctionCreatedConnection",
        "kind": "LinkedField",
        "name": "auctionCreateds",
        "plural": false,
        "selections": (v2/*: any*/),
        "storageKey": "auctionCreateds(first:1,orderBy:\"tokenId\",orderDirection:\"desc\")"
      },
      {
        "alias": null,
        "args": (v3/*: any*/),
        "filters": [
          "orderBy",
          "orderDirection"
        ],
        "handle": "connection",
        "key": "Main_auctionCreateds_auctionCreateds",
        "kind": "LinkedHandle",
        "name": "auctionCreateds"
      }
    ]
  },
  "params": {
    "cacheID": "62ab6ae45613f9141a5b147ffd57e86e",
    "id": null,
    "metadata": {
      "connection": [
        {
          "count": null,
          "cursor": null,
          "direction": "forward",
          "path": [
            "auctionCreateds"
          ]
        }
      ]
    },
    "name": "MainQuery",
    "operationKind": "query",
    "text": "query MainQuery {\n  auctionCreateds(first: 1, orderBy: tokenId, orderDirection: desc) {\n    edges {\n      node {\n        id\n        tokenId\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n"
  }
};
})() `)

include RescriptRelay.MakeLoadQuery({
    type variables = Types.variables
    type loadedQueryRef = queryRef
    type response = Types.response
    type node = relayOperationNode
    let query = node
    let convertVariables = Internal.convertVariables
});
