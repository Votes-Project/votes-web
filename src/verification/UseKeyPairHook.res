module Nacl = {
  type keyPair = {
    publicKey: Uint8Array.t,
    secretKey: Uint8Array.t,
  }
  @module("tweetnacl") @scope("box") external keyPair: unit => keyPair = "keyPair"
  @module("tweetnacl") @scope("box")
  external fromSecretKey: Uint8Array.t => keyPair = "fromSecretKey"
}

module Crypto = {
  type keyPair = {
    publicKey: Uint8Array.t,
    privateKey: Uint8Array.t,
  }
  type algorithm = | @as("ed25519") ED25519 | @as("x25519") X25519
  type format = | @as("pem") PEM | @as("der") DER | @as("raw") RAW | @as("jwk") JWK
  type \"type" = | @as("pkcs8") PKCS8 | @as("spki") SPKI | @as("sec1") SEC1
  type encoding = {
    format: format,
    \"type": \"type",
  }
  type options = {
    privateKeyEncoding: encoding,
    publicKeyEncoding: encoding,
  }
  type keyObject = {
    key: Uint8Array.t,
    format: format,
  }
  @send @scope(("crypto", "subtle"))
  external generateKey: (Dom.window, algorithm, ~options: options=?) => keyPair = "generateKey"
  @module("crypto")
  external createPublicKey: keyObject => Uint8Array.t = "createPublicKey"
}

let useKeyPair = () => {
  let localPrivateKey =
    Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_privateKey")->Option.map(Uint8Array.from)
  let localPublicKey =
    Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_publicKey")->Option.map(Uint8Array.from)

  switch (localPrivateKey, localPublicKey) {
  | (Some(publicKey), Some(privateKey)) => (publicKey, privateKey)

  | (None, Some(privateKey)) =>
    let publicKey = Crypto.createPublicKey({key: privateKey, format: JWK})
    Js.log2("publicKey: ", publicKey)
    Dom.Storage2.localStorage->Dom.Storage2.setItem(
      "votes_publicKey",
      publicKey->TypedArray.toString,
    )
    (publicKey, privateKey)

  | _ =>
    let {publicKey, privateKey} = Crypto.generateKey(
      window,
      ED25519,
      ~options={
        privateKeyEncoding: {format: JWK, \"type": PKCS8},
        publicKeyEncoding: {format: JWK, \"type": SPKI},
      },
    )

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
