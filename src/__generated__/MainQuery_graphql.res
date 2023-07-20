/* @sourceLoc Main.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_auctionSettleds_edges_node = {
    @live id: string,
    tokenId: string,
  }
  and response_auctionSettleds_edges = {node: option<response_auctionSettleds_edges_node>}
  and response_auctionSettleds = {edges: option<array<option<response_auctionSettleds_edges>>>}
  and response_questionSubmitteds_edges_node = {@live id: string}
  and response_questionSubmitteds_edges = {node: option<response_questionSubmitteds_edges_node>}
  and response_questionSubmitteds = {
    edges: option<array<option<response_questionSubmitteds_edges>>>,
  }
  type response = {
    auctionSettleds: option<response_auctionSettleds>,
    questionSubmitteds: option<response_questionSubmitteds>,
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
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(json`{}`)
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v =>
    v->RescriptRelay.convertObj(variablesConverter, variablesConverterMap, Js.undefined)
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(json`{}`)
  @live
  let wrapResponseConverterMap = ()
  @live
  let convertWrapResponse = v =>
    v->RescriptRelay.convertObj(wrapResponseConverter, wrapResponseConverterMap, Js.null)
  @live
  type responseRaw
  @live
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(json`{}`)
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v =>
    v->RescriptRelay.convertObj(responseConverter, responseConverterMap, Js.undefined)
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
}

type queryRef

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>

let node: operationType = %raw(json` (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v1 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "AuctionSettledConnection",
    "kind": "LinkedField",
    "name": "auctionSettleds",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "AuctionSettledEdge",
        "kind": "LinkedField",
        "name": "edges",
        "plural": true,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "AuctionSettled",
            "kind": "LinkedField",
            "name": "node",
            "plural": false,
            "selections": [
              (v0/*: any*/),
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "tokenId",
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "concreteType": "QuestionSubmittedConnection",
    "kind": "LinkedField",
    "name": "questionSubmitteds",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "QuestionSubmittedEdge",
        "kind": "LinkedField",
        "name": "edges",
        "plural": true,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "QuestionSubmitted",
            "kind": "LinkedField",
            "name": "node",
            "plural": false,
            "selections": [
              (v0/*: any*/)
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "MainQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "MainQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "4c52fb90421c6164d3dfcf45821f747e",
    "id": null,
    "metadata": {},
    "name": "MainQuery",
    "operationKind": "query",
    "text": "query MainQuery {\n  auctionSettleds {\n    edges {\n      node {\n        id\n        tokenId\n      }\n    }\n  }\n  questionSubmitteds {\n    edges {\n      node {\n        id\n      }\n    }\n  }\n}\n"
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
})
