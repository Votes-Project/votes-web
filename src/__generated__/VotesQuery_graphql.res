/* @sourceLoc Votes.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type response = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #Votes_VoteListDisplay_voteContract | #Votes_VoteListDisplay_votes]>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    votesContractAddress: string,
  }
  @live
  type refetchVariables = {
    votesContractAddress: option<string>,
  }
  @live let makeRefetchVariables = (
    ~votesContractAddress=?,
  ): refetchVariables => {
    votesContractAddress: votesContractAddress
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
    "name": "votesContractAddress"
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "votesContractAddress"
  }
],
v2 = [
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
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "VotesQuery",
    "selections": [
      {
        "args": null,
        "kind": "FragmentSpread",
        "name": "Votes_VoteListDisplay_votes"
      },
      {
        "args": (v1/*: any*/),
        "kind": "FragmentSpread",
        "name": "Votes_VoteListDisplay_voteContract"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "VotesQuery",
    "selections": [
      {
        "alias": null,
        "args": (v2/*: any*/),
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
                  (v3/*: any*/),
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
                    "name": "uri",
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
        "args": (v2/*: any*/),
        "filters": [
          "orderBy",
          "orderDirection",
          "where"
        ],
        "handle": "connection",
        "key": "VoteListDisplay_voteTransfers_votes",
        "kind": "LinkedHandle",
        "name": "votes"
      },
      {
        "alias": null,
        "args": (v1/*: any*/),
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
      }
    ]
  },
  "params": {
    "cacheID": "2f8863e8969906b2c52fcca58f6113d7",
    "id": null,
    "metadata": {},
    "name": "VotesQuery",
    "operationKind": "query",
    "text": "query VotesQuery(\n  $votesContractAddress: String!\n) {\n  ...Votes_VoteListDisplay_votes\n  ...Votes_VoteListDisplay_voteContract_3CfYk7\n}\n\nfragment Votes_VoteItem_vote on Vote {\n  id\n  tokenId\n  uri\n}\n\nfragment Votes_VoteListDisplay_voteContract_3CfYk7 on Query {\n  voteContract(id: $votesContractAddress) {\n    totalSupply\n    id\n  }\n}\n\nfragment Votes_VoteListDisplay_votes on Query {\n  votes(orderBy: id, orderDirection: desc, first: 1000) {\n    edges {\n      node {\n        id\n        ...Votes_VoteItem_vote\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n"
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
