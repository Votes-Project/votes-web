/* @sourceLoc SingleVote.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_auction = {
    startTime: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #AuctionDisplay_auction]>,
  }
  and fragment_voteContract = {
    totalSupply: string,
  }
  type fragment = {
    auction: option<fragment_auction>,
    owner: string,
    voteContract: option<fragment_voteContract>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"auction":{"f":""}}}`
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
  RescriptRelay.fragmentRefs<[> | #SingleVote_node]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "argumentDefinitions": [
    {
      "defaultValue": null,
      "kind": "LocalArgument",
      "name": "voteContractAddress"
    }
  ],
  "kind": "Fragment",
  "metadata": null,
  "name": "SingleVote_node",
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
        }
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
        {
          "args": null,
          "kind": "FragmentSpread",
          "name": "AuctionDisplay_auction"
        },
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "startTime",
          "storageKey": null
        }
      ],
      "storageKey": null
    }
  ],
  "type": "Vote",
  "abstractKey": null
} `)

