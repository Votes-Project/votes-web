/* @sourceLoc Votes.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_voteTransfers_edges_node = {
    @live id: string,
    tokenId: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #Votes_VoteItem_voteTransfer]>,
  }
  and fragment_voteTransfers_edges = {
    node: option<fragment_voteTransfers_edges_node>,
  }
  and fragment_voteTransfers = {
    edges: option<array<option<fragment_voteTransfers_edges>>>,
  }
  type fragment = {
    voteTransfers: option<fragment_voteTransfers>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"voteTransfers_edges_node":{"f":""}}}`
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
  RescriptRelay.fragmentRefs<[> | #Votes_VoteListDisplay_voteTransfers]> => fragmentRef = "%identity"

@live
@inline
let connectionKey = "VoteListDisplay_voteTransfers_voteTransfers"

%%private(
  @live @module("relay-runtime") @scope("ConnectionHandler")
  external internal_makeConnectionId: (RescriptRelay.dataId, @as("VoteListDisplay_voteTransfers_voteTransfers") _, 'arguments) => RescriptRelay.dataId = "getConnectionID"
)

@live
let makeConnectionId = (connectionParentDataId: RescriptRelay.dataId, ~orderBy: RelaySchemaAssets_graphql.enum_OrderBy_Transfers=TokenId, ~orderDirection: RelaySchemaAssets_graphql.enum_OrderDirection=Desc, ~where: RelaySchemaAssets_graphql.input_Where_Transfers=Obj.magic({"from": "0x0000000000000000000000000000000000000000"})) => {
  let orderBy = Some(orderBy)
  let orderDirection = Some(orderDirection)
  let where = Some(where)
  let args = {"orderBy": orderBy, "orderDirection": orderDirection, "where": where}
  internal_makeConnectionId(connectionParentDataId, args)
}
module Utils = {
  @@warning("-33")
  open Types

  @live
  let getConnectionNodes: option<Types.fragment_voteTransfers> => array<Types.fragment_voteTransfers_edges_node> = connection => 
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
      "defaultValue": 100,
      "kind": "LocalArgument",
      "name": "first"
    },
    {
      "defaultValue": "tokenId",
      "kind": "LocalArgument",
      "name": "orderBy"
    },
    {
      "defaultValue": "desc",
      "kind": "LocalArgument",
      "name": "orderDirection"
    },
    {
      "defaultValue": {
        "from": "0x0000000000000000000000000000000000000000"
      },
      "kind": "LocalArgument",
      "name": "where"
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
          "voteTransfers"
        ]
      }
    ]
  },
  "name": "Votes_VoteListDisplay_voteTransfers",
  "selections": [
    {
      "alias": "voteTransfers",
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
          "kind": "Variable",
          "name": "where",
          "variableName": "where"
        }
      ],
      "concreteType": "VoteTransferConnection",
      "kind": "LinkedField",
      "name": "__VoteListDisplay_voteTransfers_voteTransfers_connection",
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
                  "args": null,
                  "kind": "FragmentSpread",
                  "name": "Votes_VoteItem_voteTransfer"
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

