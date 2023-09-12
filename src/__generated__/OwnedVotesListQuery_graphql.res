/* @sourceLoc OwnedVotesList.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type response = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #OwnedVotesList_OwnedVotesListDisplay_votes]>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    owner: string,
  }
  @live
  type refetchVariables = {
    owner: option<string>,
  }
  @live let makeRefetchVariables = (
    ~owner=?,
  ): refetchVariables => {
    owner: owner
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
    "name": "owner"
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "owner",
    "variableName": "owner"
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
    "value": "asc"
  },
  {
    "fields": (v1/*: any*/),
    "kind": "ObjectValue",
    "name": "where"
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "OwnedVotesListQuery",
    "selections": [
      {
        "args": (v1/*: any*/),
        "kind": "FragmentSpread",
        "name": "OwnedVotesList_OwnedVotesListDisplay_votes"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "OwnedVotesListQuery",
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
        "storageKey": null
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
        "key": "OwnedVotesList_votes_votes",
        "kind": "LinkedHandle",
        "name": "votes"
      }
    ]
  },
  "params": {
    "cacheID": "5cb8e983a3e337aada6f6815a5ff9175",
    "id": null,
    "metadata": {},
    "name": "OwnedVotesListQuery",
    "operationKind": "query",
    "text": "query OwnedVotesListQuery(\n  $owner: String!\n) {\n  ...OwnedVotesList_OwnedVotesListDisplay_votes_1JS2nm\n}\n\nfragment OwnedVotesList_OwnedVoteItem_vote on Vote {\n  id\n  tokenId\n  uri\n}\n\nfragment OwnedVotesList_OwnedVotesListDisplay_votes_1JS2nm on Query {\n  votes(first: 1000, orderBy: id, orderDirection: asc, where: {owner: $owner}) {\n    edges {\n      node {\n        id\n        ...OwnedVotesList_OwnedVoteItem_vote\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n"
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
