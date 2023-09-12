/* @generated */
@@warning("-30")

@live @unboxed
type enum_OrderBy_AuctionBids = 
  | @as("id") Id
  | @as("tokenId") TokenId
  | @as("blockTimestamp") BlockTimestamp
  | @as("amount") Amount
  | FutureAddedValue(string)


@live @unboxed
type enum_OrderBy_AuctionBids_input = 
  | @as("id") Id
  | @as("tokenId") TokenId
  | @as("blockTimestamp") BlockTimestamp
  | @as("amount") Amount


@live @unboxed
type enum_OrderBy_AuctionCreateds = 
  | @as("id") Id
  | @as("tokenId") TokenId
  | FutureAddedValue(string)


@live @unboxed
type enum_OrderBy_AuctionCreateds_input = 
  | @as("id") Id
  | @as("tokenId") TokenId


@live @unboxed
type enum_OrderBy_AuctionSettleds = 
  | @as("id") Id
  | @as("tokenId") TokenId
  | @as("winner") Winner
  | FutureAddedValue(string)


@live @unboxed
type enum_OrderBy_AuctionSettleds_input = 
  | @as("id") Id
  | @as("tokenId") TokenId
  | @as("winner") Winner


@live @unboxed
type enum_OrderBy_Transfers = 
  | @as("id") Id
  | @as("tokenId") TokenId
  | @as("winner") Winner
  | @as("blockNumber") BlockNumber
  | FutureAddedValue(string)


@live @unboxed
type enum_OrderBy_Transfers_input = 
  | @as("id") Id
  | @as("tokenId") TokenId
  | @as("winner") Winner
  | @as("blockNumber") BlockNumber


@live @unboxed
type enum_OrderBy_Votes = 
  | @as("id") Id
  | @as("owner") Owner
  | FutureAddedValue(string)


@live @unboxed
type enum_OrderBy_Votes_input = 
  | @as("id") Id
  | @as("owner") Owner


@live @unboxed
type enum_OrderDirection = 
  | @as("asc") Asc
  | @as("desc") Desc
  | FutureAddedValue(string)


@live @unboxed
type enum_OrderDirection_input = 
  | @as("asc") Asc
  | @as("desc") Desc


@live @unboxed
type enum_SubgraphError = 
  | @as("allow") Allow
  | @as("deny") Deny
  | FutureAddedValue(string)


@live @unboxed
type enum_SubgraphError_input = 
  | @as("allow") Allow
  | @as("deny") Deny


@live @unboxed
type enum_RequiredFieldAction = 
  | NONE
  | LOG
  | THROW
  | FutureAddedValue(string)


@live @unboxed
type enum_RequiredFieldAction_input = 
  | NONE
  | LOG
  | THROW


@live
type rec input_Where_AuctionBids = {
  id?: string,
  tokenId?: string,
}

@live
and input_Where_AuctionBids_nullable = {
  id?: Js.Null.t<string>,
  tokenId?: Js.Null.t<string>,
}

@live
and input_Where_AuctionCreateds = {
  id?: string,
  tokenId?: string,
}

@live
and input_Where_AuctionCreateds_nullable = {
  id?: Js.Null.t<string>,
  tokenId?: Js.Null.t<string>,
}

@live
and input_Where_Transfers = {
  id?: string,
  tokenId?: string,
  from?: string,
}

@live
and input_Where_Transfers_nullable = {
  id?: Js.Null.t<string>,
  tokenId?: Js.Null.t<string>,
  from?: Js.Null.t<string>,
}

@live
and input_Where_Votes = {
  id?: string,
  owner?: string,
}

@live
and input_Where_Votes_nullable = {
  id?: Js.Null.t<string>,
  owner?: Js.Null.t<string>,
}
