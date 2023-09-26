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
v1 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 1000
  },
  {
    "kind": "Literal",
    "name": "orderBy",
    "value": "id"
  },
  {
    "kind": "Literal",
    "name": "orderDirection",
    "value": "desc"
  }
],
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "tokenId",
  "storageKey": null
};
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
        "args": (v1/*: any*/),
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
                  (v2/*: any*/),
                  (v3/*: any*/),
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
                      (v2/*: any*/),
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
                          (v3/*: any*/),
                          (v2/*: any*/)
                        ],
                        "storageKey": null
                      },
                      {
                        "alias": null,
                        "args": null,
                        "kind": "ScalarField",
                        "name": "amount",
                        "storageKey": null
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
                      (v2/*: any*/)
                    ],
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
        "storageKey": "votes(first:1000,orderBy:\"id\",orderDirection:\"desc\")"
      },
      {
        "alias": null,
        "args": (v1/*: any*/),
        "filters": [
          "orderBy",
          "orderDirection"
        ],
        "handle": "connection",
        "key": "Main_votes_votes",
        "kind": "LinkedHandle",
        "name": "votes"
      }
    ]
  },
  "params": {
    "cacheID": "8128e6c5661dc759d9785c80855725b3",
    "id": null,
    "metadata": {},
    "name": "MainQuery",
    "operationKind": "query",
    "text": "query MainQuery(\n  $voteContract: String!\n) {\n  ...MainFragment_1AeezH\n}\n\nfragment AuctionCountdown_auction on Auction {\n  endTime\n}\n\nfragment AuctionDisplay_auction on Auction {\n  id\n  startTime\n  endTime\n  bidder\n  settled\n  vote {\n    tokenId\n    id\n  }\n  amount\n  ...CreateBid_auction\n  ...AuctionCountdown_auction\n}\n\nfragment CreateBid_auction on Auction {\n  vote {\n    tokenId\n    id\n  }\n}\n\nfragment MainFragment_1AeezH on Query {\n  votes(orderBy: id, orderDirection: desc, first: 1000) {\n    edges {\n      node {\n        id\n        tokenId\n        owner\n        auction {\n          ...AuctionDisplay_auction\n          id\n        }\n        ...SingleVote_node_TkrmL\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment SingleVote_node_TkrmL on Vote {\n  owner\n  voteContract(id: $voteContract) {\n    totalSupply\n    id\n  }\n  auction {\n    ...AuctionDisplay_auction\n    startTime\n    id\n  }\n}\n"
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
