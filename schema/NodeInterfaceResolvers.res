/** Fetches an object given its ID.*/
@gql.field
let node = async (_: Schema.query, ~id, ~ctx: ResGraphContext.context): option<
  Interface_node.Resolver.t,
> => {
  switch id->ResGraph.idToString->ResGraph.Utils.Base64.decode->String.split(":") {
  | [typenameAsString, id] =>
    switch typenameAsString->Interface_node.ImplementedBy.decode {
    | None => None
    | Some(Auction) =>
      switch await ctx.dataLoaders.auction.byId->DataLoader.load(id) {
      | None => panic("Did not find auction with that ID")
      | Some(auction) => Auction(auction)->Some
      }
    | Some(AuctionSettled) =>
      switch await ctx.dataLoaders.auctionSettled.byId->DataLoader.load(id) {
      | None => panic("Did not find auction settled with that ID")
      | Some(auctionSettled) => AuctionSettled(auctionSettled)->Some
      }
    | Some(QuestionSubmitted) =>
      switch await ctx.dataLoaders.questionSubmitted.byId->DataLoader.load(id) {
      | None => panic("Did not find question submitted with that ID")
      | Some(questionSubmitted) => QuestionSubmitted(questionSubmitted)->Some
      }
    | Some(AuctionCreated) =>
      switch await ctx.dataLoaders.auctionCreated.byId->DataLoader.load(id) {
      | None => panic("Did not find auction created with that ID")
      | Some(auctionCreated) => AuctionCreated(auctionCreated)->Some
      }
    | Some(AuctionBid) =>
      switch await ctx.dataLoaders.auctionBid.byId->DataLoader.load(id) {
      | None => panic("Did not find auction bid with that ID")
      | Some(auctionBid) => AuctionBid(auctionBid)->Some
      }
    | Some(VoteTransfer) =>
      switch await ctx.dataLoaders.voteTransfer.byId->DataLoader.load(id) {
      | None => panic("Something went wrong querying vote transfer nodes")
      | Some(voteTransfer) => VoteTransfer(voteTransfer)->Some
      }
    | Some(Vote) =>
      switch await ctx.dataLoaders.vote.byId->DataLoader.load(id) {
      | None => panic("Something went wrong querying vote node")
      | Some(vote) => Vote(vote)->Some
      }
    | Some(VoteContract) =>
      switch await ctx.dataLoaders.voteContract.byId->DataLoader.load(id) {
      | None => panic("Something went wrong querying vote transfer nodes")
      | Some(voteContract) => VoteContract(voteContract)->Some
      }
    | Some(VerificationData) =>
      switch await ctx.dataLoaders.verification.byId->DataLoader.load(id) {
      | None => panic("Something went wrong querying BrightID nodes")
      | Some(verification) =>
        switch verification {
        | Verification(verificationData) => VerificationData(verificationData)->Some
        | BrightIdError(e) => panic(e.errorMessage)
        }
      }
    | Some(VerificationsData) =>
      switch await ctx.dataLoaders.verifications.byId->DataLoader.load(id) {
      | None => panic("Something went wrong querying BrightID node")
      | Some(verifications) =>
        switch verifications {
        | Verifications(verificationsData) => VerificationsData(verificationsData)->Some
        | BrightIdError(e) => panic(e.errorMessage)
        }
      }
    | Some(AuctionContract) =>
      switch await ctx.dataLoaders.auctionContract.byId->DataLoader.load(id) {
      | None => panic("Something went wrong querying auction contract node")
      | Some(auctionContract) => AuctionContract(auctionContract)->Some
      }
    | Some(Question) =>
      switch await ctx.dataLoaders.question.byId->DataLoader.load(id) {
      | None => panic("Something went wrong querying question node")
      | Some(question) => Question(question)->Some
      }
    }

  | _ => None
  }
}

/** Fetches objects given their IDs. */
@gql.field
let nodes = (query: Schema.query, ~ids, ~ctx: ResGraphContext.context) => {
  ids->Array.map(id => node(query, ~id, ~ctx))
}

@gql.field
let id = (node: NodeInterface.node, ~typename: Interface_node.ImplementedBy.t) => {
  `${typename->Interface_node.ImplementedBy.toString}:${node.id}`
  ->ResGraph.Utils.Base64.encode
  ->ResGraph.id
}
