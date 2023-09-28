/* @sourceLoc AuctionDisplay.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_vote = {
    tokenId: string,
  }
  type fragment = {
    amount: string,
    bidder: option<string>,
    endTime: string,
    @live id: string,
    settled: bool,
    startTime: string,
    vote: fragment_vote,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #AllBidsList_auction | #AuctionBidList_auction | #AuctionCountdown_auction | #CreateBid_auction]>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"":{"f":""}}}`
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
  RescriptRelay.fragmentRefs<[> | #AuctionDisplay_auction]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "AuctionDisplay_auction",
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
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "tokenId",
          "storageKey": null
        }
      ],
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
      "name": "CreateBid_auction"
    },
    {
      "args": null,
      "kind": "FragmentSpread",
      "name": "AuctionCountdown_auction"
    },
    {
      "args": null,
      "kind": "FragmentSpread",
      "name": "AuctionBidList_auction"
    },
    {
      "args": null,
      "kind": "FragmentSpread",
      "name": "AllBidsList_auction"
    }
  ],
  "type": "Auction",
  "abstractKey": null
} `)

