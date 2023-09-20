/* @sourceLoc AllBidsList.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_auctionBids_edges_node = {
    amount: string,
    @live id: string,
    tokenId: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #AllBidsList_BidItem_auctionBid]>,
  }
  and fragment_auctionBids_edges = {
    @live __id: RescriptRelay.dataId,
    node: option<fragment_auctionBids_edges_node>,
  }
  and fragment_auctionBids = {
    @live __id: RescriptRelay.dataId,
    edges: option<array<option<fragment_auctionBids_edges>>>,
  }
  type fragment = {
    auctionBids: option<fragment_auctionBids>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"auctionBids_edges_node":{"f":""}}}`
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
  RescriptRelay.fragmentRefs<[> | #AllBidsListDisplay_auctionBids]> => fragmentRef = "%identity"

@live
@inline
let connectionKey = "AllBidsListDisplay_auctionBids_auctionBids"

%%private(
  @live @module("relay-runtime") @scope("ConnectionHandler")
  external internal_makeConnectionId: (RescriptRelay.dataId, @as("AllBidsListDisplay_auctionBids_auctionBids") _, 'arguments) => RescriptRelay.dataId = "getConnectionID"
)

@live
let makeConnectionId = (connectionParentDataId: RescriptRelay.dataId, ~orderBy: RelaySchemaAssets_graphql.enum_OrderBy_AuctionBids=TokenId, ~orderDirection: RelaySchemaAssets_graphql.enum_OrderDirection=Desc, ~where: option<RelaySchemaAssets_graphql.input_Where_AuctionBids>=?) => {
  let orderBy = Some(orderBy)
  let orderDirection = Some(orderDirection)
  let args = {"orderBy": orderBy, "orderDirection": orderDirection, "where": where}
  internal_makeConnectionId(connectionParentDataId, args)
}
module Utils = {
  @@warning("-33")
  open Types

  @live
  let getConnectionNodes: option<Types.fragment_auctionBids> => array<Types.fragment_auctionBids_edges_node> = connection => 
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


let node: operationType = %raw(json` (function(){
var v0 = {
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
  "argumentDefinitions": [
    {
      "defaultValue": 1000,
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
      "defaultValue": null,
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
          "auctionBids"
        ]
      }
    ]
  },
  "name": "AllBidsListDisplay_auctionBids",
  "selections": [
    {
      "alias": "auctionBids",
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
      "concreteType": "AuctionBidConnection",
      "kind": "LinkedField",
      "name": "__AllBidsListDisplay_auctionBids_auctionBids_connection",
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
                  "args": null,
                  "kind": "FragmentSpread",
                  "name": "AllBidsList_BidItem_auctionBid"
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
            },
            (v0/*: any*/)
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
        (v0/*: any*/)
      ],
      "storageKey": null
    }
  ],
  "type": "Query",
  "abstractKey": null
};
})() `)

