/* @sourceLoc DailyQuestion.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type fragment = 
    | BrightIdError(
      {
        @live __typename: [ | #BrightIdError],
        error: bool,
      }
    )
    | VerificationData(
      {
        @live __typename: [ | #VerificationData],
        contextIds: array<string>,
        @live id: string,
        unique: bool,
      }
    )
    | @as("__unselected") UnselectedUnionMember(string)

}

@live
let unwrap_fragment: Types.fragment => Types.fragment = RescriptRelay_Internal.unwrapUnion(_, ["BrightIdError", "VerificationData"])
@live
let wrap_fragment: Types.fragment => Types.fragment = RescriptRelay_Internal.wrapUnion
module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"":{"u":"fragment"}}}`
  )
  @live
  let fragmentConverterMap = {
    "fragment": unwrap_fragment,
  }
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
  RescriptRelay.fragmentRefs<[> | #DailyQuestion_verification]> => fragmentRef = "%identity"

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
  "name": "DailyQuestion_verification",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "__typename",
      "storageKey": null
    },
    {
      "kind": "InlineFragment",
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
          "name": "unique",
          "storageKey": null
        },
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "contextIds",
          "storageKey": null
        }
      ],
      "type": "VerificationData",
      "abstractKey": null
    },
    {
      "kind": "InlineFragment",
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "error",
          "storageKey": null
        }
      ],
      "type": "BrightIdError",
      "abstractKey": null
    }
  ],
  "type": "Verification",
  "abstractKey": "__isVerification"
} `)

