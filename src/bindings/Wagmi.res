type client
type connector
type abi = JSON.t
type value = BigInt.t

module BlockExplorer = {
  type t = {name: string, url: string}
}
module Chain = {
  type blockExplorers = Dict.t<BlockExplorer.t>
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
  type unsupportedChain = {unsupported: bool, ...t}
}

type transactionResponse = {hash: string}
type mode = | @as("prepared") Prepared | @as("signing") Signing | @as("sending") Sending
type writeContractParameters
type preparedResult
type preparedResponse = {
  mode: mode,
  request: writeContractParameters,
  result: option<preparedResult>,
}

type accountStatus =
  | @as("connecting") Connecting
  | @as("reconnecting") Reconnecting
  | @as("connected") Connected
  | @as("disconnected") Disconnected

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
  value: BigInt.t,
}

module WagmiConfig = {
  @react.component @module("wagmi")
  external make: (~config: 'a, ~children: React.element) => React.element = "WagmiConfig"
}

type signMessageReturn = {
  signMessage: unit => unit,
  ...queryResult<string>,
}
@module("wagmi")
external useSignMessage: 'a => signMessageReturn = "useSignMessage"

type useBalanceInput = {address: Nullable.t<string>, ...queryInput<balanceData>}
@module("wagmi")
external useBalance: useBalanceInput => queryResult<balanceData> = "useBalance"

type ensNameInput = {address: string, ...queryInput<string>}
@module("wagmi") external useEnsName: ensNameInput => queryResult<string> = "useEnsName"

type usePrepareContractWriteReturn<'args> = {config: contractConfig<'args>}
@module("wagmi")
external usePrepareContractWrite: (
  ~config: contractConfig<'args>=?,
) => usePrepareContractWriteReturn<'args> = "usePrepareContractWrite"

@module("wagmi")
external useContractWrite: contractConfig<'args> => mutationReturn<'args> = "useContractWrite"

module UseContractEvent = {
  type eventLog<'args> = {
    address: string,
    args: 'args,
    blockHash: string,
    blockNumber: BigInt.t,
    data: string,
    eventName: string,
    logIndex: int,
    removed: bool,
    topics: array<string>,
    transactionHash: string,
    transactionIndex: int,
  }
  type input<'args> = {
    address: string,
    abi: JSON.t,
    eventName: string,
    listener: array<eventLog<'args>> => unit,
    chainId?: int,
  }
  @module("wagmi")
  external make: input<'args> => unit = "useContractEvent"
}

module UseAccount = {
  type onConnect = {address: string, connector: connector, isReconnected: bool}

  type t = {
    address: Nullable.t<string>,
    connector: Nullable.t<connector>,
    isConnecting: bool,
    isReconnecting: bool,
    isConnected: bool,
    isDisconnected: bool,
    status: accountStatus,
  }
  type useAccountInput = {onConnect?: onConnect => unit, onDisconnect?: unit => unit}
  @module("wagmi") @module("wagmi")
  external make: (~config: useAccountInput=?) => t = "useAccount"
}

module Network = {
  type useNetworkReturn = {
    chains: array<Chain.t>,
    chain: Nullable.t<Chain.unsupportedChain>,
  }
  @module("wagmi")
  external use: unit => useNetworkReturn = "useNetwork"
}

module PublicClient = {
  type t = Viem.publicClient
  @module("wagmi") external use: unit => t = "usePublicClient"
}
