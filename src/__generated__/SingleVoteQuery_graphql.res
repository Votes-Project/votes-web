/* @sourceLoc SingleVote.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_node = {
    @live __typename: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #SingleVote_node]>,
  }
  type response = {
    node: option<response_node>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    @live id: string,
    voteContractAddress: string,
  }
  @live
  type refetchVariables = {
    @live id: option<string>,
    voteContractAddress: option<string>,
  }
  @live let makeRefetchVariables = (
    ~id=?,
    ~voteContractAddress=?,
  ): refetchVariables => {
    id: id,
    voteContractAddress: voteContractAddress
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
    json`{"__root":{"node":{"f":""}}}`
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
    json`{"__root":{"node":{"f":""}}}`
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
    "name": "id"
  },
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "voteContractAddress"
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "id"
  }
],
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
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
  "name": "bidder",
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
  "name": "amount",
  "storageKey": null
},
v7 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 1000
  },
  {
    "kind": "Literal",
    "name": "orderBy",
    "value": "blockTimestamp"
  },
  {
    "kind": "Literal",
    "name": "orderDirection",
    "value": "desc"
  }
],
v8 = {
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
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "SingleVoteQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          {
            "args": [
              {
                "kind": "Variable",
                "name": "voteContractAddress",
                "variableName": "voteContractAddress"
              }
            ],
            "kind": "FragmentSpread",
            "name": "SingleVote_node"
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "SingleVoteQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          (v3/*: any*/),
          {
            "kind": "InlineFragment",
            "selections": [
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "owner",
                "storageKey": null
              },
              {
                "alias": null,
                "args": [
                  {
                    "kind": "Variable",
                    "name": "id",
                    "variableName": "voteContractAddress"
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
                  (v3/*: any*/)
                ],
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
                  (v3/*: any*/),
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
                  (v4/*: any*/),
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
                      (v3/*: any*/)
                    ],
                    "storageKey": null
                  },
                  (v6/*: any*/),
                  {
                    "alias": null,
                    "args": (v7/*: any*/),
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
                              (v3/*: any*/),
                              (v5/*: any*/),
                              (v6/*: any*/),
                              (v4/*: any*/),
                              (v2/*: any*/)
                            ],
                            "storageKey": null
                          },
                          {
                            "alias": null,
                            "args": null,
                            "kind": "ScalarField",
                            "name": "cursor",
                            "storageKey": null
                          },
                          (v8/*: any*/)
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
                      },
                      (v8/*: any*/)
                    ],
                    "storageKey": "bids(first:1000,orderBy:\"blockTimestamp\",orderDirection:\"desc\")"
                  },
                  {
                    "alias": null,
                    "args": (v7/*: any*/),
                    "filters": [
                      "orderBy",
                      "orderDirection"
                    ],
                    "handle": "connection",
                    "key": "AuctionBidList_bids_bids",
                    "kind": "LinkedHandle",
                    "name": "bids"
                  },
                  {
                    "alias": null,
                    "args": (v7/*: any*/),
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
              (v5/*: any*/)
            ],
            "type": "Vote",
            "abstractKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "2ece588b304efb6cc4ca0868b6753408",
    "id": null,
    "metadata": {},
    "name": "SingleVoteQuery",
    "operationKind": "query",
    "text": "query SingleVoteQuery(\n  $id: ID!\n  $voteContractAddress: String!\n) {\n  node(id: $id) {\n    __typename\n    ...SingleVote_node_1WFVmm\n    id\n  }\n}\n\nfragment AllBidsList_BidItem_auctionBid on AuctionBid {\n  id\n  tokenId\n  bidder\n  amount\n}\n\nfragment AllBidsList_auction on Auction {\n  bids(orderBy: blockTimestamp, orderDirection: desc, first: 1000) {\n    edges {\n      node {\n        id\n        tokenId\n        amount\n        ...AllBidsList_BidItem_auctionBid\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment AuctionBidList_AuctionBidItem_auctionBid on AuctionBid {\n  id\n  tokenId\n  bidder\n  amount\n}\n\nfragment AuctionBidList_auction on Auction {\n  bids(orderBy: blockTimestamp, orderDirection: desc, first: 1000) {\n    edges {\n      node {\n        id\n        tokenId\n        amount\n        ...AuctionBidList_AuctionBidItem_auctionBid\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment AuctionCountdown_auction on Auction {\n  endTime\n}\n\nfragment AuctionDisplay_auction on Auction {\n  id\n  startTime\n  endTime\n  bidder\n  settled\n  vote {\n    tokenId\n    id\n  }\n  amount\n  ...CreateBid_auction\n  ...AuctionCountdown_auction\n  ...AuctionBidList_auction\n  ...AllBidsList_auction\n}\n\nfragment CreateBid_auction on Auction {\n  vote {\n    tokenId\n    id\n  }\n}\n\nfragment Raffle_vote on Vote {\n  id\n  tokenId\n}\n\nfragment SingleVote_node_1WFVmm on Vote {\n  owner\n  voteContract(id: $voteContractAddress) {\n    totalSupply\n    id\n  }\n  auction {\n    ...AuctionDisplay_auction\n    startTime\n    id\n  }\n  ...Raffle_vote\n}\n"
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
