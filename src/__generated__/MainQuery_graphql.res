/* @sourceLoc Main.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type response = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #MainFragment]>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    voteContract: string,
  }
  @live
  type refetchVariables = {
    voteContract: option<string>,
  }
  @live let makeRefetchVariables = (
    ~voteContract=?,
  ): refetchVariables => {
    voteContract: voteContract
  }

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
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "voteContract"
  }
],
v1 = {
  "kind": "Literal",
  "name": "first",
  "value": 1000
},
v2 = {
  "kind": "Literal",
  "name": "orderDirection",
  "value": "desc"
},
v3 = [
  (v1/*: any*/),
  {
    "kind": "Literal",
    "name": "orderBy",
    "value": "id"
  },
  (v2/*: any*/)
],
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "tokenId",
  "storageKey": null
},
v6 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "bidder",
  "storageKey": null
},
v7 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "amount",
  "storageKey": null
},
v8 = [
  (v1/*: any*/),
  {
    "kind": "Literal",
    "name": "orderBy",
    "value": "blockTimestamp"
  },
  (v2/*: any*/)
],
v9 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v10 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "cursor",
  "storageKey": null
},
v11 = {
  "kind": "ClientExtension",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "__id",
      "storageKey": null
    }
  ]
},
v12 = {
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
v13 = [
  "orderBy",
  "orderDirection"
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "MainQuery",
    "selections": [
      {
        "args": [
          {
            "kind": "Variable",
            "name": "voteContract",
            "variableName": "voteContract"
          }
        ],
        "kind": "FragmentSpread",
        "name": "MainFragment"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "MainQuery",
    "selections": [
      {
        "alias": null,
        "args": (v3/*: any*/),
        "concreteType": "VoteConnection",
        "kind": "LinkedField",
        "name": "votes",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "VoteEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": "Vote",
                "kind": "LinkedField",
                "name": "node",
                "plural": false,
                "selections": [
                  (v4/*: any*/),
                  (v5/*: any*/),
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "owner",
                    "storageKey": null
                  },
                  {
                    "alias": null,
                    "args": null,
                    "concreteType": "Auction",
                    "kind": "LinkedField",
                    "name": "auction",
                    "plural": false,
                    "selections": [
                      (v4/*: any*/),
                      {
                        "alias": null,
                        "args": null,
                        "kind": "ScalarField",
                        "name": "startTime",
                        "storageKey": null
                      },
                      {
                        "alias": null,
                        "args": null,
                        "kind": "ScalarField",
                        "name": "endTime",
                        "storageKey": null
                      },
                      (v6/*: any*/),
                      {
                        "alias": null,
                        "args": null,
                        "kind": "ScalarField",
                        "name": "settled",
                        "storageKey": null
                      },
                      {
                        "alias": null,
                        "args": null,
                        "concreteType": "Vote",
                        "kind": "LinkedField",
                        "name": "vote",
                        "plural": false,
                        "selections": [
                          (v5/*: any*/),
                          (v4/*: any*/)
                        ],
                        "storageKey": null
                      },
                      (v7/*: any*/),
                      {
                        "alias": null,
                        "args": (v8/*: any*/),
                        "concreteType": "AuctionBidConnection",
                        "kind": "LinkedField",
                        "name": "bids",
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
                                  (v4/*: any*/),
                                  (v5/*: any*/),
                                  (v7/*: any*/),
                                  (v6/*: any*/),
                                  (v9/*: any*/)
                                ],
                                "storageKey": null
                              },
                              (v10/*: any*/),
                              (v11/*: any*/)
                            ],
                            "storageKey": null
                          },
                          (v12/*: any*/),
                          (v11/*: any*/)
                        ],
                        "storageKey": "bids(first:1000,orderBy:\"blockTimestamp\",orderDirection:\"desc\")"
                      },
                      {
                        "alias": null,
                        "args": (v8/*: any*/),
                        "filters": (v13/*: any*/),
                        "handle": "connection",
                        "key": "AuctionBidList_bids_bids",
                        "kind": "LinkedHandle",
                        "name": "bids"
                      },
                      {
                        "alias": null,
                        "args": (v8/*: any*/),
                        "filters": [
                          "orderBy",
                          "orderDirection",
                          "where"
                        ],
                        "handle": "connection",
                        "key": "AllBidsList_bids_bids",
                        "kind": "LinkedHandle",
                        "name": "bids"
                      }
                    ],
                    "storageKey": null
                  },
                  {
                    "alias": null,
                    "args": [
                      {
                        "kind": "Variable",
                        "name": "id",
                        "variableName": "voteContract"
                      }
                    ],
                    "concreteType": "VoteContract",
                    "kind": "LinkedField",
                    "name": "voteContract",
                    "plural": false,
                    "selections": [
                      {
                        "alias": null,
                        "args": null,
                        "kind": "ScalarField",
                        "name": "totalSupply",
                        "storageKey": null
                      },
                      (v4/*: any*/)
                    ],
                    "storageKey": null
                  },
                  (v9/*: any*/)
                ],
                "storageKey": null
              },
              (v10/*: any*/)
            ],
            "storageKey": null
          },
          (v12/*: any*/)
        ],
        "storageKey": "votes(first:1000,orderBy:\"id\",orderDirection:\"desc\")"
      },
      {
        "alias": null,
        "args": (v3/*: any*/),
        "filters": (v13/*: any*/),
        "handle": "connection",
        "key": "Main_votes_votes",
        "kind": "LinkedHandle",
        "name": "votes"
      }
    ]
  },
  "params": {
    "cacheID": "e1b8ed1b5e20b39d0257f608962d893e",
    "id": null,
    "metadata": {},
    "name": "MainQuery",
    "operationKind": "query",
    "text": "query MainQuery(\n  $voteContract: String!\n) {\n  ...MainFragment_1AeezH\n}\n\nfragment AllBidsList_BidItem_auctionBid on AuctionBid {\n  id\n  tokenId\n  bidder\n  amount\n}\n\nfragment AllBidsList_auction on Auction {\n  bids(orderBy: blockTimestamp, orderDirection: desc, first: 1000) {\n    edges {\n      node {\n        id\n        tokenId\n        amount\n        ...AllBidsList_BidItem_auctionBid\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment AuctionBidList_AuctionBidItem_auctionBid on AuctionBid {\n  id\n  tokenId\n  bidder\n  amount\n}\n\nfragment AuctionBidList_auction on Auction {\n  bids(orderBy: blockTimestamp, orderDirection: desc, first: 1000) {\n    edges {\n      node {\n        id\n        tokenId\n        amount\n        ...AuctionBidList_AuctionBidItem_auctionBid\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment AuctionCountdown_auction on Auction {\n  endTime\n}\n\nfragment AuctionDisplay_auction on Auction {\n  id\n  startTime\n  endTime\n  bidder\n  settled\n  vote {\n    tokenId\n    id\n  }\n  amount\n  ...CreateBid_auction\n  ...AuctionCountdown_auction\n  ...AuctionBidList_auction\n  ...AllBidsList_auction\n}\n\nfragment CreateBid_auction on Auction {\n  vote {\n    tokenId\n    id\n  }\n}\n\nfragment MainFragment_1AeezH on Query {\n  votes(orderBy: id, orderDirection: desc, first: 1000) {\n    edges {\n      node {\n        id\n        tokenId\n        owner\n        auction {\n          ...AuctionDisplay_auction\n          id\n        }\n        ...SingleVote_node_TkrmL\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment Raffle_vote on Vote {\n  id\n  tokenId\n}\n\nfragment SingleVote_node_TkrmL on Vote {\n  owner\n  voteContract(id: $voteContract) {\n    totalSupply\n    id\n  }\n  auction {\n    ...AuctionDisplay_auction\n    startTime\n    id\n  }\n  ...Raffle_vote\n}\n"
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
