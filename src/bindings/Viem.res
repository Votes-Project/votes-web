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
