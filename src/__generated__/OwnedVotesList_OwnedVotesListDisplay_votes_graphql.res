/* @sourceLoc OwnedVotesList.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_votes_edges_node = {
    @live id: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #OwnedVotesList_OwnedVoteItem_vote]>,
  }
  and fragment_votes_edges = {
    node: option<fragment_votes_edges_node>,
  }
  and fragment_votes = {
    edges: option<array<option<fragment_votes_edges>>>,
  }
  type fragment = {
    votes: option<fragment_votes>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"votes_edges_node":{"f":""}}}`
  )
  @live
  let fragmentConverterMap = ()
  @live
  let convertFragment = v => v->RescriptRelay.convertObj(
    fragmentConverter,
    fragmentConverterMap,
    Js.undefined
  )
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #OwnedVotesList_OwnedVotesListDisplay_votes]> => fragmentRef = "%identity"

@live
@inline
let connectionKey = "OwnedVotesList_votes_votes"

%%private(
  @live @module("relay-runtime") @scope("ConnectionHandler")
  external internal_makeConnectionId: (RescriptRelay.dataId, @as("OwnedVotesList_votes_votes") _, 'arguments) => RescriptRelay.dataId = "getConnectionID"
)

@live
let makeConnectionId = (connectionParentDataId: RescriptRelay.dataId, ~orderBy: RelaySchemaAssets_graphql.enum_OrderBy_Votes=Id, ~orderDirection: RelaySchemaAssets_graphql.enum_OrderDirection=Asc, ~owner: option<string>=?) => {
  let orderBy = Some(orderBy)
  let orderDirection = Some(orderDirection)
  let args = {"orderBy": orderBy, "orderDirection": orderDirection, "where": {"owner": owner}}
  internal_makeConnectionId(connectionParentDataId, args)
}
module Utils = {
  @@warning("-33")
  open Types

  @live
  let getConnectionNodes: option<Types.fragment_votes> => array<Types.fragment_votes_edges_node> = connection => 
    switch connection {
      | None => []
      | Some(connection) => 
        switch connection.edges {
          | None => []
          | Some(edges) => edges
            ->Belt.Array.keepMap(edge => switch edge {
              | None => None
              | Some(edge) => edge.node
            })
        }
    }


}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "argumentDefinitions": [
    {
      "defaultValue": 1000,
      "kind": "LocalArgument",
      "name": "first"
    },
    {
      "defaultValue": "id",
      "kind": "LocalArgument",
      "name": "orderBy"
    },
    {
      "defaultValue": "asc",
      "kind": "LocalArgument",
      "name": "orderDirection"
    },
    {
      "defaultValue": null,
      "kind": "LocalArgument",
      "name": "owner"
    }
  ],
  "kind": "Fragment",
  "metadata": {
    "connection": [
      {
        "count": "first",
        "cursor": null,
        "direction": "forward",
        "path": [
          "votes"
        ]
      }
    ]
  },
  "name": "OwnedVotesList_OwnedVotesListDisplay_votes",
  "selections": [
    {
      "alias": "votes",
      "args": [
        {
          "kind": "Variable",
          "name": "orderBy",
          "variableName": "orderBy"
        },
        {
          "kind": "Variable",
          "name": "orderDirection",
          "variableName": "orderDirection"
        },
        {
          "fields": [
            {
              "kind": "Variable",
              "name": "owner",
              "variableName": "owner"
            }
          ],
          "kind": "ObjectValue",
          "name": "where"
        }
      ],
      "concreteType": "VoteConnection",
      "kind": "LinkedField",
      "name": "__OwnedVotesList_votes_votes_connection",
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
                  "args": null,
                  "kind": "FragmentSpread",
                  "name": "OwnedVotesList_OwnedVoteItem_vote"
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
    }
  ],
  "type": "Query",
  "abstractKey": null
} `)

