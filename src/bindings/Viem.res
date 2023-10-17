@module("viem") external formatUnits: (BigInt.t, int) => string = "formatUnits"
@module("viem") external formatEther: BigInt.t => string = "formatEther"
@module("viem") external parseEther: string => option<BigInt.t> = "parseEther"
@module("viem") external isAddress: string => bool = "isAddress"

type getEnsAddressInput = {name: string}
@module("viem")
external getEnsAddress: getEnsAddressInput => promise<Nullable.t<string>> = "getEnsAddress"
@module("viem")
external normalize: string => string = "normalize"
