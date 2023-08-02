type client
type chain
type connector

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

type queryResult<'data> = {
  data: Nullable.t<'data>,
  error: Nullable.t<Exn.t>,
  isIdle: bool,
  isLoading: bool,
  isFetching: bool,
  isSuccess: bool,
  isError: bool,
  isFetched: bool,
  isFetchedAfterMount: bool,
  isRefetching: bool,
  status: status,
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
