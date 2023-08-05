type client
type connector
type abi = JSON.t
type value = BigInt.t
module Chain = {
  type blockExplorers
  type contracts
  type rpcUrls

  type t = {
    id: int,
    blockExplorers: blockExplorers,
    contracts: contracts,
    name: string,
    testnet: bool,
    rpcUrls: rpcUrls,
  }
}

type transactionResponse = {hash: string}

type accountStatus =
  | @as("connecting") Connecting
  | @as("reconnecting") Reconnecting
  | @as("connected") Connected
  | @as("disconnected") Disconnected

type account = {
  address: Nullable.t<string>,
  connector: Nullable.t<connector>,
  isConnecting: bool,
  isReconnecting: bool,
  isConnected: bool,
  isDisconnected: bool,
  status: accountStatus,
}

type input = {
  chainId?: int,
  cacheTime?: int,
  enabled?: bool,
  scopeKey?: string,
  staleTime?: int,
  suspense?: bool,
}

type queryInput<'data> = {
  onSuccess?: Nullable.t<'data> => unit,
  onError?: Nullable.t<Exn.t> => unit,
  onSettled?: (Nullable.t<'data>, Nullable.t<Exn.t>) => unit,
  ...input,
}

type status =
  | @as("idle") Idle | @as("error") Error | @as("loading") Loading | @as("success") Success

type result<'data> = {
  data: Nullable.t<'data>,
  error: Nullable.t<Exn.t>,
  isIdle: bool,
  isLoading: bool,
  isSuccess: bool,
  isError: bool,
  status: status,
}

type queryResult<'data> = {
  isFetched: bool,
  isFetchedAfterMount: bool,
  isRefetching: bool,
  ...result<'data>,
}

type overrides = {
  from?: string,
  gasPrice?: string,
  gasLimit?: string,
  nonce?: string,
  value?: string,
}

type onMutateInput<'args> = {
  args: 'args,
  overrides: overrides,
}

type mutationInput<'args> = {
  args?: 'args,
  account?: string,
  value?: value,
  onMutate?: onMutateInput<'args> => unit,
  onSuccess?: Nullable.t<transactionResponse> => unit,
  onError?: Nullable.t<Exn.t> => unit,
  onSettled?: (Nullable.t<transactionResponse>, Nullable.t<Exn.t>) => unit,
  ...input,
}

type contractConfig<'args> = {
  address?: string,
  abi: abi,
  functionName: string,
  ...mutationInput<'args>,
}

type mutationReturn<'args> = {
  write?: (~config: mutationInput<'args>=?) => unit,
  writeAsync?: (~config: mutationInput<'args>=?) => Promise.t<transactionResponse>,
  reset?: unit => unit,
  ...result<string>,
}

type balanceData = {
  decimals: int,
  formatted: string,
  symbol: string,
  value: string,
}

module WagmiConfig = {
  @react.component @module("wagmi")
  external make: (~config: 'a, ~children: React.element) => React.element = "WagmiConfig"
}

@module("wagmi")
external useAccount: unit => account = "useAccount"

type signMessageReturn = {
  signMessage: unit => unit,
  ...queryResult<string>,
}
@module("wagmi")
external useSignMessage: 'a => signMessageReturn = "useSignMessage"

@module("wagmi")
external useBalance: 'a => queryResult<balanceData> = "useBalance"

type ensNameInput = {address: string, ...queryInput<string>}
@module("wagmi") external useEnsName: ensNameInput => queryResult<string> = "useEnsName"

type usePrepareContractWriteReturn<'args> = {config: contractConfig<'args>}
@module("wagmi")
external usePrepareContractWrite: (
  ~config: contractConfig<'args>=?,
) => usePrepareContractWriteReturn<'args> = "usePrepareContractWrite"

@module("wagmi")
external useContractWrite: contractConfig<'args> => mutationReturn<'args> = "useContractWrite"

type unsupportedChain = {unsupported: bool, ...Chain.t}
type useNetworkReturn = {chain?: unsupportedChain, chains: array<Chain.t>}
@module("wagmi")
external useNetwork: unit => useNetworkReturn = "useNetwork"
