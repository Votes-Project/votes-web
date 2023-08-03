@module("viem") external formatUnits: (BigInt.t, int) => string = "formatUnits"
@module("viem") external formatEther: BigInt.t => string = "formatEther"
@module("viem") external parseEther: string => option<BigInt.t> = "parseEther"
