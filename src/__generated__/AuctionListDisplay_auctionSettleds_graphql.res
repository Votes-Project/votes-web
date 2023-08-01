/* @sourceLoc AuctionListDisplay.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_auctionSettleds_edges_node = {
    @live id: string,
    tokenId: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #AuctionItem_auctionSettled]>,
  }
  and fragment_auctionSettleds_edges = {
    node: option<fragment_auctionSettleds_edges_node>,
  }
  and fragment_auctionSettleds = {
    edges: option<array<option<fragment_auctionSettleds_edges>>>,
  }
  type fragment = {
    auctionSettleds: option<fragment_auctionSettleds>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"auctionSettleds_edges_node":{"f":""}}}`
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
  RescriptRelay.fragmentRefs<[> | #AuctionListDisplay_auctionSettleds]> => fragmentRef = "%identity"

@live
@inline
let connectionKey = "AuctionListDisplay_auctionSettleds_auctionSettleds"

%%private(
  @live @module("relay-runtime") @scope("ConnectionHandler")
  external internal_makeConnectionId: (RescriptRelay.dataId, @as("AuctionListDisplay_auctionSettleds_auctionSettleds") _, 'arguments) => RescriptRelay.dataId = "getConnectionID"
)

@live
let makeConnectionId = (connectionParentDataId: RescriptRelay.dataId, ~orderBy: RelaySchemaAssets_graphql.enum_OrderBy_AuctionSettleds=TokenId, ~orderDirection: RelaySchemaAssets_graphql.enum_OrderDirection=Desc) => {
  let orderBy = Some(orderBy)
  let orderDirection = Some(orderDirection)
  let args = {"orderBy": orderBy, "orderDirection": orderDirection}
  internal_makeConnectionId(connectionParentDataId, args)
}
module Utils = {
  @@warning("-33")
  open Types

  @live
  let getConnectionNodes: option<Types.fragment_auctionSettleds> => array<Types.fragment_auctionSettleds_edges_node> = connection => 
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
      "defaultValue": 5,
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
          "auctionSettleds"
        ]
      }
    ]
  },
  "name": "AuctionListDisplay_auctionSettleds",
  "selections": [
    {
      "alias": "auctionSettleds",
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
        }
      ],
      "concreteType": "AuctionSettledConnection",
      "kind": "LinkedField",
      "name": "__AuctionListDisplay_auctionSettleds_auctionSettleds_connection",
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
                  "name": "AuctionItem_auctionSettled"
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

