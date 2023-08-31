module Nacl = {
  type keyPair = {
    publicKey: Uint8Array.t,
    secretKey: Uint8Array.t,
  }
  @module("tweetnacl") @scope("box") external keyPair: unit => keyPair = "keyPair"
  @module("tweetnacl") @scope("box")
  external fromSecretKey: Uint8Array.t => keyPair = "fromSecretKey"
}

let useKeyPair = () => {
  let localPrivateKey =
    Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_privateKey")->Option.map(Uint8Array.from)
  let localPublicKey =
    Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_publicKey")->Option.map(Uint8Array.from)

  switch (localPrivateKey, localPublicKey) {
  | (Some(publicKey), Some(privateKey)) => (publicKey, privateKey)

  | (None, Some(privateKey)) =>
    let {publicKey} = Nacl.fromSecretKey(privateKey)
    Dom.Storage2.localStorage->Dom.Storage2.setItem(
      "votes_publicKey",
      publicKey->TypedArray.toString,
    )
    (publicKey, privateKey)

  | _ =>
    let {publicKey, secretKey: privateKey} = Nacl.keyPair()

    Dom.Storage2.localStorage->Dom.Storage2.setItem(
      "votes_publicKey",
      publicKey->TypedArray.toString,
    )

    Dom.Storage2.localStorage->Dom.Storage2.setItem(
      "votes_privateKey",
      privateKey->TypedArray.toString,
    )

    (publicKey, privateKey) //This provides bad typing because they both look like stirngs to the consumer. There is probably a more ergonomic way to type this
  }
}
