type client
type chain
type connector
type abi = JSON.t
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

type queryInput<'data> = {
  chainId?: int,
  cacheTime?: int,
  enabled?: bool,
  scopeKey?: string,
  staleTime?: int,
  suspense?: bool,
  onSuccess?: Nullable.t<'data> => unit,
  onError?: Nullable.t<Exn.t> => unit,
  onSettled?: (Nullable.t<'data>, Nullable.t<Exn.t>) => unit,
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
  address?: string,
  abi: abi,
  functionName: string,
  chainId?: int,
  args?: 'args,
  account?: string,
  value?: string,
  onMutate?: onMutateInput<'args> => unit,
  onSuccess?: Nullable.t<transactionResponse> => unit,
  onError?: Nullable.t<Exn.t> => unit,
  onSettled?: (Nullable.t<transactionResponse>, Nullable.t<Exn.t>) => unit,
}
type contractConfig<'args> = {
  ...mutationInput<'args>,
}

type mutationReturn<'args> = {
  write: (~config: contractConfig<'args>=?) => unit,
  writeAsync: (~config: contractConfig<'args>=?) => Promise.t<transactionResponse>,
  reset: unit => unit,
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
  ~config: mutationInput<'args>=?,
) => usePrepareContractWriteReturn<'args> = "usePrepareContractWrite"

@module("wagmi")
external useContractWrite: contractConfig<'args> => mutationReturn<'args> = "useContractWrite"
