/* @sourceLoc RequireVerification.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type fragment = {
    contextIds: array<string>,
    @live id: string,
    unique: bool,
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
  RescriptRelay.fragmentRefs<[> | #RequireVerification_verification]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


%%private(let makeNode = (rescript_graphql_node_VerificationRefetchQuery): operationType => {
  ignore(rescript_graphql_node_VerificationRefetchQuery)
  %raw(json`{
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": {
    "refetch": {
      "connection": null,
      "fragmentPathInResult": [
        "node"
      ],
      "operation": rescript_graphql_node_VerificationRefetchQuery,
      "identifierField": "id"
    }
  },
  "name": "RequireVerification_verification",
  "selections": [
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
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "id",
      "storageKey": null
    }
  ],
  "type": "Verification",
  "abstractKey": null
}`)
})
let node: operationType = makeNode(VerificationRefetchQuery_graphql.node)

