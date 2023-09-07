/* @sourceLoc AuctionList.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type response = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #AuctionListDisplay_auctionCreateds | #AuctionListDisplay_auctionSettleds | #AuctionListDisplay_voteTransfers]>,
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
    "kind": "Literal",
    "name": "first",
    "value": 5
  },
  (v0/*: any*/),
  (v1/*: any*/)
],
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "tokenId",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v6 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "cursor",
  "storageKey": null
},
v7 = {
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
},
v8 = [
  "orderBy",
  "orderDirection"
],
v9 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 1000
  },
  (v0/*: any*/),
  (v1/*: any*/),
  {
    "kind": "Literal",
    "name": "where",
    "value": {
      "from": "0x0000000000000000000000000000000000000000"
    }
  }
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "AuctionListQuery",
    "selections": [
      {
        "args": null,
        "kind": "FragmentSpread",
        "name": "AuctionListDisplay_auctionCreateds"
      },
      {
        "args": null,
        "kind": "FragmentSpread",
        "name": "AuctionListDisplay_auctionSettleds"
      },
      {
        "args": null,
        "kind": "FragmentSpread",
        "name": "AuctionListDisplay_voteTransfers"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "AuctionListQuery",
    "selections": [
      {
        "alias": null,
        "args": (v2/*: any*/),
        "concreteType": "AuctionCreatedConnection",
        "kind": "LinkedField",
        "name": "auctionCreateds",
        "plural": false,
        "selections": [
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
                  (v3/*: any*/),
                  (v4/*: any*/),
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "endTime",
                    "storageKey": null
                  },
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "startTime",
                    "storageKey": null
                  },
                  (v5/*: any*/)
                ],
                "storageKey": null
              },
              (v6/*: any*/)
            ],
            "storageKey": null
          },
          (v7/*: any*/)
        ],
        "storageKey": "auctionCreateds(first:5,orderBy:\"tokenId\",orderDirection:\"desc\")"
      },
      {
        "alias": null,
        "args": (v2/*: any*/),
        "filters": (v8/*: any*/),
        "handle": "connection",
        "key": "AuctionListDisplay_auctionCreateds_auctionCreateds",
        "kind": "LinkedHandle",
        "name": "auctionCreateds"
      },
      {
        "alias": null,
        "args": (v2/*: any*/),
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
                  (v3/*: any*/),
                  (v4/*: any*/),
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "winner",
                    "storageKey": null
                  },
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "amount",
                    "storageKey": null
                  },
                  (v5/*: any*/)
                ],
                "storageKey": null
              },
              (v6/*: any*/)
            ],
            "storageKey": null
          },
          (v7/*: any*/)
        ],
        "storageKey": "auctionSettleds(first:5,orderBy:\"tokenId\",orderDirection:\"desc\")"
      },
      {
        "alias": null,
        "args": (v2/*: any*/),
        "filters": (v8/*: any*/),
        "handle": "connection",
        "key": "AuctionListDisplay_auctionSettleds_auctionSettleds",
        "kind": "LinkedHandle",
        "name": "auctionSettleds"
      },
      {
        "alias": null,
        "args": (v9/*: any*/),
        "concreteType": "VoteTransferConnection",
        "kind": "LinkedField",
        "name": "voteTransfers",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "VoteTransferEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": "VoteTransfer",
                "kind": "LinkedField",
                "name": "node",
                "plural": false,
                "selections": [
                  (v3/*: any*/),
                  (v4/*: any*/),
                  (v5/*: any*/)
                ],
                "storageKey": null
              },
              (v6/*: any*/)
            ],
            "storageKey": null
          },
          (v7/*: any*/)
        ],
        "storageKey": "voteTransfers(first:1000,orderBy:\"tokenId\",orderDirection:\"desc\",where:{\"from\":\"0x0000000000000000000000000000000000000000\"})"
      },
      {
        "alias": null,
        "args": (v9/*: any*/),
        "filters": [
          "orderBy",
          "orderDirection",
          "where"
        ],
        "handle": "connection",
        "key": "AuctionListDisplay_voteTransfers_voteTransfers",
        "kind": "LinkedHandle",
        "name": "voteTransfers"
      }
    ]
  },
  "params": {
    "cacheID": "c4c9cb88ae6613bdc1f60e9a6dc7f7bb",
    "id": null,
    "metadata": {},
    "name": "AuctionListQuery",
    "operationKind": "query",
    "text": "query AuctionListQuery {\n  ...AuctionListDisplay_auctionCreateds\n  ...AuctionListDisplay_auctionSettleds\n  ...AuctionListDisplay_voteTransfers\n}\n\nfragment AuctionCountdown_auctionCreated on AuctionCreated {\n  endTime\n}\n\nfragment AuctionListDisplay_auctionCreateds on Query {\n  auctionCreateds(orderBy: tokenId, orderDirection: desc, first: 5) {\n    edges {\n      node {\n        id\n        tokenId\n        endTime\n        ...AuctionList_AuctionItem_auctionCreated\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment AuctionListDisplay_auctionSettleds on Query {\n  auctionSettleds(orderBy: tokenId, orderDirection: desc, first: 5) {\n    edges {\n      node {\n        id\n        tokenId\n        ...AuctionList_AuctionItem_auctionSettled\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment AuctionListDisplay_voteTransfers on Query {\n  voteTransfers(orderBy: tokenId, orderDirection: desc, first: 1000, where: {from: \"0x0000000000000000000000000000000000000000\"}) {\n    edges {\n      node {\n        id\n        tokenId\n        ...AuctionList_AuctionItem_voteTransfers\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment AuctionList_AuctionItem_auctionCreated on AuctionCreated {\n  id\n  tokenId\n  startTime\n  endTime\n  ...CreateBid_auctionCreated\n  ...AuctionCountdown_auctionCreated\n}\n\nfragment AuctionList_AuctionItem_auctionSettled on AuctionSettled {\n  id\n  tokenId\n  winner\n  amount\n}\n\nfragment AuctionList_AuctionItem_voteTransfers on VoteTransfer {\n  id\n  tokenId\n}\n\nfragment CreateBid_auctionCreated on AuctionCreated {\n  tokenId\n}\n"
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
