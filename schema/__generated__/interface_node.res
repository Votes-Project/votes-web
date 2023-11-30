/* @generated */

@@warning("-27-34-37")

module Resolver = {
  @gql.interfaceResolver("node")
  type t =
    | Answer(Answer.answer)
    | Auction(Auction.auction)
    | AuctionBid(AuctionBid.auctionBid)
    | AuctionContract(AuctionContract.auctionContract)
    | AuctionCreated(AuctionCreated.auctionCreated)
    | AuctionSettled(AuctionSettled.auctionSettled)
    | Question(Question.question)
    | QuestionSubmitted(QuestionSubmitted.questionSubmitted)
    | TriviaQuestion(Question.triviaQuestion)
    | Tweet(Twitter.tweet)
    | TwitterToken(Twitter.twitterToken)
    | VerificationData(Verification.verificationData)
    | VerificationsData(Verifications.verificationsData)
    | Vote(Vote.vote)
    | VoteContract(VoteContract.voteContract)
    | VoteTransfer(VoteTransfer.voteTransfer)
}

module ImplementedBy = {
  type t =
    | Answer
    | Auction
    | AuctionBid
    | AuctionContract
    | AuctionCreated
    | AuctionSettled
    | Question
    | QuestionSubmitted
    | TriviaQuestion
    | Tweet
    | TwitterToken
    | VerificationData
    | VerificationsData
    | Vote
    | VoteContract
    | VoteTransfer

  let decode = (str: string) =>
    switch str {
    | "Answer" => Some(Answer)
    | "Auction" => Some(Auction)
    | "AuctionBid" => Some(AuctionBid)
    | "AuctionContract" => Some(AuctionContract)
    | "AuctionCreated" => Some(AuctionCreated)
    | "AuctionSettled" => Some(AuctionSettled)
    | "Question" => Some(Question)
    | "QuestionSubmitted" => Some(QuestionSubmitted)
    | "TriviaQuestion" => Some(TriviaQuestion)
    | "Tweet" => Some(Tweet)
    | "TwitterToken" => Some(TwitterToken)
    | "VerificationData" => Some(VerificationData)
    | "VerificationsData" => Some(VerificationsData)
    | "Vote" => Some(Vote)
    | "VoteContract" => Some(VoteContract)
    | "VoteTransfer" => Some(VoteTransfer)
    | _ => None
    }

  external toString: t => string = "%identity"
}

type typeMap<'a> = {
  @as("Answer") answer: 'a,
  @as("Auction") auction: 'a,
  @as("AuctionBid") auctionBid: 'a,
  @as("AuctionContract") auctionContract: 'a,
  @as("AuctionCreated") auctionCreated: 'a,
  @as("AuctionSettled") auctionSettled: 'a,
  @as("Question") question: 'a,
  @as("QuestionSubmitted") questionSubmitted: 'a,
  @as("TriviaQuestion") triviaQuestion: 'a,
  @as("Tweet") tweet: 'a,
  @as("TwitterToken") twitterToken: 'a,
  @as("VerificationData") verificationData: 'a,
  @as("VerificationsData") verificationsData: 'a,
  @as("Vote") vote: 'a,
  @as("VoteContract") voteContract: 'a,
  @as("VoteTransfer") voteTransfer: 'a,
}

module TypeMap: {
  type t<'value>
  let make: (typeMap<'value>, ~valueToString: 'value => string) => t<'value>

  /** Takes a (stringified) value and returns what type it represents, if any. */
  let getTypeByStringifiedValue: (t<'value>, string) => option<ImplementedBy.t>

  /** Takes a type and returns what value it represents, as string. */
  let getStringifiedValueByType: (t<'value>, ImplementedBy.t) => string
} = {
  external unsafe_toDict: typeMap<'value> => Js.Dict.t<'value> = "%identity"
  external unsafe_toType: string => ImplementedBy.t = "%identity"
  type t<'value> = {
    typeToValue: Js.Dict.t<'value>,
    valueToTypeAsString: Js.Dict.t<string>,
    valueToString: 'value => string,
  }
  let make = (typeMap, ~valueToString) => {
    typeToValue: typeMap->unsafe_toDict,
    valueToTypeAsString: typeMap
    ->unsafe_toDict
    ->Js.Dict.entries
    ->Array.map(((key, value)) => (valueToString(value), key))
    ->Js.Dict.fromArray,
    valueToString,
  }

  let getStringifiedValueByType = (t, typ) =>
    t.typeToValue->Dict.get(typ->ImplementedBy.toString)->Option.getExn->t.valueToString
  let getTypeByStringifiedValue = (t, str) =>
    t.valueToTypeAsString->Dict.get(str)->Option.map(unsafe_toType)
}
