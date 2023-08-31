include Uint8Array

let parse = (x: string) => Uint8Array.from(x)->Some
let serialize = (x: Uint8Array.t) => TypedArray.toString(x)
