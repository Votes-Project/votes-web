/* @sourceLoc LinkBrightID.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_verification = {
    @live __typename: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #DailyQuestion_verification | #LinkBrightID_verification]>,
  }
  type response = {
    verification: response_verification,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    contextId: string,
  }
  @live
  type refetchVariables = {
    contextId: option<string>,
  }
  @live let makeRefetchVariables = (
    ~contextId=?,
  ): refetchVariables => {
    contextId: contextId
  }

}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"verification":{"f":""}}}`
  )
  @live
  let wrapResponseConverterMap = ()
  @live
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    Js.null
  )
  @live
  type responseRaw
  @live
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"verification":{"f":""}}}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
}

type queryRef

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "contextId"
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "contextId",
    "variableName": "contextId"
  }
],
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "LinkBrightIDQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "verification",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "LinkBrightID_verification"
          },
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "DailyQuestion_verification"
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "LinkBrightIDQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "verification",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          {
            "kind": "TypeDiscriminator",
            "abstractKey": "__isVerification"
          },
          {
            "kind": "InlineFragment",
            "selections": [
              (v3/*: any*/),
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
          },
          {
            "kind": "InlineFragment",
            "selections": [
              (v3/*: any*/)
            ],
            "type": "Node",
            "abstractKey": "__isNode"
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "dc61fde7cea0022fbc96d7b3c8b1b04e",
    "id": null,
    "metadata": {},
    "name": "LinkBrightIDQuery",
    "operationKind": "query",
    "text": "query LinkBrightIDQuery(\n  $contextId: String!\n) {\n  verification(contextId: $contextId) {\n    __typename\n    ...LinkBrightID_verification\n    ...DailyQuestion_verification\n    ... on Node {\n      __isNode: __typename\n      __typename\n      id\n    }\n  }\n}\n\nfragment DailyQuestion_verification on Verification {\n  __isVerification: __typename\n  __typename\n  ... on VerificationData {\n    id\n    unique\n    contextIds\n  }\n  ... on BrightIdError {\n    error\n  }\n}\n\nfragment LinkBrightID_verification on Verification {\n  __isVerification: __typename\n  __typename\n  ... on VerificationData {\n    id\n    unique\n    contextIds\n  }\n  ... on BrightIdError {\n    error\n  }\n}\n"
  }
};
})() `)

include RescriptRelay.MakeLoadQuery({
    type variables = Types.variables
    type loadedQueryRef = queryRef
    type response = Types.response
    type node = relayOperationNode
    let query = node
    let convertVariables = Internal.convertVariables
});
