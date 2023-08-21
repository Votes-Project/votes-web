module Nacl = {
  type keyPair = {
    publicKey: Uint8Array.t,
    privateKey: Uint8Array.t,
  }
  @module("tweetnacl") @scope("box") external keyPair: unit => keyPair = "keyPair"
  @module("tweetnacl") @scope("box") external fromSecretKey: string => keyPair = "fromSecretKey"
}

type keyPair = {
  publicKey: option<string>,
  privateKey: option<string>,
}
let useKeyPair = () => {
  let localPrivateKey = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_privateKey")
  let localPublicKey = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_publicKey")
  let (keyPair, setKeyPair) = React.useState(_ => {
    publicKey: localPrivateKey,
    privateKey: localPublicKey,
  })

  switch keyPair {
  | {publicKey: Some(publicKey), privateKey: Some(privateKey)} =>
    setKeyPair(_ => {publicKey: Some(publicKey), privateKey: Some(privateKey)})

  | {publicKey: None, privateKey: Some(privateKey)} =>
    let publicKey = Nacl.fromSecretKey(privateKey).publicKey->TypedArray.toString
    setKeyPair(_ => {publicKey: Some(publicKey), privateKey: Some(privateKey)})

  | _ =>
    let {publicKey, privateKey} = Nacl.keyPair()
    let publicKey = publicKey->TypedArray.toString
    let privateKey = privateKey->TypedArray.toString

    Dom.Storage2.localStorage->Dom.Storage2.setItem("votes_publicKey", publicKey)->ignore

    Dom.Storage2.localStorage->Dom.Storage2.setItem("votes_privateKey", privateKey)->ignore

    setKeyPair(_ => {publicKey: Some(publicKey), privateKey: Some(privateKey)})
  }

  keyPair
}
