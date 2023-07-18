open AuctionSettled
module Node = {
  type data = {auctionSettled: auctionSettled}
  @module("../../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionSettledDocument"

  @gql.field
  let auctionSettled = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
    auctionSettled,
  > => {
    switch await ctx.dataLoaders.auctionSettled.byId->DataLoader.load(id) {
    | None => panic("Did not find auction settled with that ID")
    | Some(auctionSettled) => auctionSettled->Some
    }
  }
}

module Connection = {
  type data = {auctionSettleds: array<auctionSettled>}
  @module("../../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetAuctionSettledsDocument"

  @gql.field
  let auctionSettleds = async (_: Schema.query, ~skip, ~first, ~after, ~before, ~last): option<
    auctionSettledConnection,
  > => {
    open GraphClient

    let res = await executeWithVars(
      document,
      {first: first->Option.getWithDefault(10), skip: skip->Option.getWithDefault(0)}, //Probably shouldn't have to write defaults here
    )

    res.data->Option.map(data =>
      data.auctionSettleds
      ->Array.map(auctionSettled => (auctionSettled :> AuctionSettled.auctionSettled))
      ->ResGraph.Connections.connectionFromArray(~args={first: None, after, before, last})
    )
  }
}
