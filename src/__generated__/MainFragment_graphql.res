/* @sourceLoc Main.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_votes_edges_node_auction = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #AuctionDisplay_auction]>,
  }
  and fragment_votes_edges_node = {
    auction: option<fragment_votes_edges_node_auction>,
    @live id: string,
    owner: string,
    tokenId: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #SingleVote_node]>,
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
    json`{"__root":{"votes_edges_node_auction":{"f":""},"votes_edges_node":{"f":""}}}`
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
  RescriptRelay.fragmentRefs<[> | #MainFragment]> => fragmentRef = "%identity"

@live
@inline
let connectionKey = "Main_votes_votes"

%%private(
  @live @module("relay-runtime") @scope("ConnectionHandler")
  external internal_makeConnectionId: (RescriptRelay.dataId, @as("Main_votes_votes") _, 'arguments) => RescriptRelay.dataId = "getConnectionID"
)

@live
let makeConnectionId = (connectionParentDataId: RescriptRelay.dataId, ) => {
  let args = {"orderBy": Some("id"), "orderDirection": Some("desc")}
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
      "defaultValue": null,
      "kind": "LocalArgument",
      "name": "voteContract"
    }
  ],
  "kind": "Fragment",
  "metadata": {
    "connection": [
      {
        "count": null,
        "cursor": null,
        "direction": "forward",
        "path": [
          "votes"
        ]
      }
    ]
  },
  "name": "MainFragment",
  "selections": [
    {
      "alias": "votes",
      "args": [
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
      "concreteType": "VoteConnection",
      "kind": "LinkedField",
      "name": "__Main_votes_votes_connection",
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
                    {
                      "args": null,
                      "kind": "FragmentSpread",
                      "name": "AuctionDisplay_auction"
                    }
                  ],
                  "storageKey": null
                },
                {
                  "args": [
                    {
                      "kind": "Variable",
                      "name": "voteContractAddress",
                      "variableName": "voteContract"
                    }
                  ],
                  "kind": "FragmentSpread",
                  "name": "SingleVote_node"
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
      "storageKey": "__Main_votes_votes_connection(orderBy:\"id\",orderDirection:\"desc\")"
    }
  ],
  "type": "Query",
  "abstractKey": null
} `)

