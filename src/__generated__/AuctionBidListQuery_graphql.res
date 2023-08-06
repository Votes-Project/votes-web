/* @sourceLoc AuctionBidList.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type response = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #AuctionBidListDisplay_auctionBids]>,
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
    json`{"__root":{"":{"f":""}}}`
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
    json`{"__root":{"":{"f":""}}}`
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

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 1000
  },
  {
    "kind": "Literal",
    "name": "orderBy",
    "value": "tokenId"
  },
  {
    "kind": "Literal",
    "name": "orderDirection",
    "value": "desc"
  }
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "AuctionBidListQuery",
    "selections": [
      {
        "args": null,
        "kind": "FragmentSpread",
        "name": "AuctionBidListDisplay_auctionBids"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "AuctionBidListQuery",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": "AuctionBidConnection",
        "kind": "LinkedField",
        "name": "auctionBids",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "AuctionBidEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": "AuctionBid",
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
                    "name": "amount",
                    "storageKey": null
                  },
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "bidder",
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
        "storageKey": "auctionBids(first:1000,orderBy:\"tokenId\",orderDirection:\"desc\")"
      },
      {
        "alias": null,
        "args": (v0/*: any*/),
        "filters": [
          "orderBy",
          "orderDirection"
        ],
        "handle": "connection",
        "key": "AuctionBidListDisplay_auctionBids_auctionBids",
        "kind": "LinkedHandle",
        "name": "auctionBids"
      }
    ]
  },
  "params": {
    "cacheID": "f6e615b87b6bf6962d48493556c0b480",
    "id": null,
    "metadata": {},
    "name": "AuctionBidListQuery",
    "operationKind": "query",
    "text": "query AuctionBidListQuery {\n  ...AuctionBidListDisplay_auctionBids\n}\n\nfragment AuctionBidListDisplay_auctionBids on Query {\n  auctionBids(orderBy: tokenId, orderDirection: desc, first: 1000) {\n    edges {\n      node {\n        id\n        tokenId\n        amount\n        ...AuctionBidList_AuctionBidItem_auctionBid\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment AuctionBidList_AuctionBidItem_auctionBid on AuctionBid {\n  id\n  tokenId\n  bidder\n  amount\n}\n"
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
