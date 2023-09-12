/* @sourceLoc Votes.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_voteContract = {
    totalSupply: string,
  }
  type fragment = {
    voteContract: option<fragment_voteContract>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
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
  RescriptRelay.fragmentRefs<[> | #Votes_VoteListDisplay_voteContract]> => fragmentRef = "%identity"

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
      "name": "id"
    }
  ],
  "kind": "Fragment",
  "metadata": null,
  "name": "Votes_VoteListDisplay_voteContract",
  "selections": [
    {
      "alias": null,
      "args": [
        {
          "kind": "Variable",
          "name": "id",
          "variableName": "id"
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
    }
  ],
  "type": "Query",
  "abstractKey": null
} `)

