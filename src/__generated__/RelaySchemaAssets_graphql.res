/* @generated */
@@warning("-30")

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
  | @as("price") Price
  | FutureAddedValue(string)


@live @unboxed
type enum_OrderBy_AuctionSettleds_input = 
  | @as("id") Id
  | @as("tokenId") TokenId
  | @as("price") Price


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


