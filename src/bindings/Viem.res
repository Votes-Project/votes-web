type publicClient
@module("viem") external formatUnits: (BigInt.t, int) => string = "formatUnits"
@module("viem") external formatEther: BigInt.t => string = "formatEther"
@module("viem") external parseEther: string => option<BigInt.t> = "parseEther"
@module("viem") external isAddress: string => bool = "isAddress"

type getEnsAddressInput = {name: string}
@send
external getEnsAddress: (publicClient, getEnsAddressInput) => promise<Nullable.t<string>> =
  "getEnsAddress"
@module("viem/ens")
external normalize: string => string = "normalize"

@module("viem") external toHexFromString: string => string = "toHex"

@module("viem") external hexToString: string => string = "hexToString"
@module("viem") external hexToBytes: string => Uint8Array.t = "hexToBytes"
