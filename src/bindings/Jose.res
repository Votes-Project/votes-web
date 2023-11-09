type alg = | @string PS256 | @string ES256
type crv = | @string Ed448
type cryptoKey
module JWK = {
  @tag("crv")
  type publicKey = | @as("P-256") ES256({crv: crv, x: string, y: string})
  type privateKey = | @as("P-256") ES256({crv: crv, x: string, y: string, d: string})
  @tag("")
  type t = PublicKey(publicKey) | PrivateKey(privateKey)
}
type keyPair = {
  publicKey: cryptoKey,
  privateKey: cryptoKey,
}
type options = {extractable?: bool, crv?: crv}
@module("jose")
external generateKeyPair: (alg, ~options: options=?) => Promise.t<keyPair> = "generateKeyPair"
@module("jose")
external importJWK: (JWK.t, ~alg: alg=?) => Promise.t<Uint8Array.t> = "importJWK"
@module("jose") @module("jose") @module("jose")
external exportJWK: cryptoKey => Promise.t<JWK.t> = "exportJWK"
@module("jose")
external importSPKI: (string, ~alg: alg=?, ~options: options=?) => Promise.t<cryptoKey> =
  "importSPKI"
@module("jose") external exportSPKI: cryptoKey => Promise.t<string> = "exportSPKI"
@module("jose")
external importPKCS8: (string, ~alg: alg=?, ~options: options=?) => Promise.t<cryptoKey> =
  "importPKCS8"
@module("jose") external exportPKCS8: cryptoKey => Promise.t<string> = "exportPKCS8"

@module("jose") external keyToJWK: cryptoKey => Promise.t<JWK.t> = "keyToJWK"
@module("jose") external jwkToKey: JWK.t => Promise.t<cryptoKey> = "jwkToKey"
@module("jose")
external calculateJwkThumbprint: JWK.t => Promise.t<string> = "calculateJwkThumbprint"

module JWT = {
  type t
  type header = {
    jwk: JWK.t,
    alg?: alg,
  }
  module Sign = {
    @module("jose") @new external make: JSON.t => t = "SignJWT"
    @send external setProtectedHeader: (t, header) => t = "setProtectedHeader"
    @send external sign: (t, cryptoKey) => Promise.t<string> = "sign"
  }
  module Verify = {
    type t<'data> = {
      payload: 'data,
      protectedHeader: header,
    }
    @module("jose")
    external make: (string, Uint8Array.t) => Promise.t<t<'data>> = "jwtVerify"
    @module("jose")
    external decodeProtectedHeader: string => header = "decodeProtectedHeader"
  }
}
