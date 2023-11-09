type keyPair = {
  publicKey: string,
  privateKey: string,
  jwk: Jose.JWK.t,
  contextId: string,
}

let useKeyPair = () => {
  let localPrivateKey = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_privateKey")
  let localPublicKey = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_publicKey")
  let (keyPair, setKeyPair) = React.useState(() => None)

  React.useEffect0(() => {
    let make = async () => {
      open Promise
      switch (localPublicKey, localPrivateKey) {
      | (Some(publicKey), Some(privateKey)) =>
        let (jwk, contextId) = switch await Jose.importSPKI(
          publicKey,
          ~alg=ES256,
          ~options={extractable: true},
        ) {
        | spki =>
          let jwk = await Jose.exportJWK(spki)
          let contextId = await Jose.calculateJwkThumbprint(jwk)
          (jwk, contextId)
        }
        setKeyPair(_ => Some({
          publicKey,
          privateKey,
          jwk,
          contextId,
        }))
      | exception _ => {
          Dom.Storage2.localStorage->Dom.Storage2.removeItem("votes_publicKey")
          Dom.Storage2.localStorage->Dom.Storage2.removeItem("votes_privateKey")
          setKeyPair(_ => None)
        }

      | _ =>
        switch await Jose.generateKeyPair(
          ES256,
          ~options={
            extractable: true,
          },
        ) {
        | {publicKey, privateKey} =>
          switch (
            await Jose.exportSPKI(publicKey),
            await Jose.exportPKCS8(privateKey),
            await Jose.exportJWK(publicKey),
            await {Jose.exportJWK(publicKey)}->then(Jose.calculateJwkThumbprint),
          ) {
          | (publicKey, privateKey, jwk, contextId) =>
            Dom.Storage2.localStorage->Dom.Storage2.setItem("votes_publicKey", publicKey)
            Dom.Storage2.localStorage->Dom.Storage2.setItem("votes_privateKey", privateKey)
            setKeyPair(_ => Some({publicKey, privateKey, jwk, contextId}))
          }
        | exception e => raise(e)
        }
      }
    }
    make()->ignore
    None
  })
  keyPair
}
