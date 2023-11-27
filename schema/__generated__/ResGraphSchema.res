@@warning("-27-32")

open ResGraph__GraphQLJs

let typeUnwrapper: 'src => 'return = %raw(`function typeUnwrapper(src) { if (src == null) return null; if (typeof src === 'object' && src.hasOwnProperty('_0')) return src['_0']; return src;}`)
type inputObjectFieldConverterFn
external makeInputObjectFieldConverterFn: ('a => 'b) => inputObjectFieldConverterFn = "%identity"

let applyConversionToInputObject: (
  'a,
  array<(string, inputObjectFieldConverterFn)>,
) => 'a = %raw(`function applyConversionToInputObject(obj, instructions) {
      if (instructions.length === 0) return obj;
      let newObj = Object.assign({}, obj);
      instructions.forEach(instruction => {
        let value = newObj[instruction[0]];
         newObj[instruction[0]] = instruction[1](value);
      })
      return newObj;
    }`)

let scalar_BigInt = GraphQLScalar.make({
  let config: GraphQLScalar.config<Schema.BigInt.t> = {
    name: "BigInt",
    description: "A number with arbitrary precision",
    parseValue: Schema.BigInt.parseValue,
    serialize: Schema.BigInt.serialize,
  }
  config
})
let scalar_Timestamp = GraphQLScalar.make({
  let config: GraphQLScalar.config<Schema.Timestamp.t> = {
    name: "Timestamp",
    description: "A timestamp.",
    parseValue: Schema.Timestamp.parseValue,
    serialize: Schema.Timestamp.serialize,
  }
  config
})
let enum_OrderBy_AuctionBids = GraphQLEnumType.make({
  name: "OrderBy_AuctionBids",
  description: ?None,
  values: {
    "id": {GraphQLEnumType.value: "id", description: ?None, deprecationReason: ?None},
    "tokenId": {GraphQLEnumType.value: "tokenId", description: ?None, deprecationReason: ?None},
    "blockTimestamp": {
      GraphQLEnumType.value: "blockTimestamp",
      description: ?None,
      deprecationReason: ?None,
    },
    "amount": {GraphQLEnumType.value: "amount", description: ?None, deprecationReason: ?None},
  }->makeEnumValues,
})
let enum_OrderBy_AuctionCreateds = GraphQLEnumType.make({
  name: "OrderBy_AuctionCreateds",
  description: ?None,
  values: {
    "id": {GraphQLEnumType.value: "id", description: ?None, deprecationReason: ?None},
    "tokenId": {GraphQLEnumType.value: "tokenId", description: ?None, deprecationReason: ?None},
  }->makeEnumValues,
})
let enum_OrderBy_AuctionSettleds = GraphQLEnumType.make({
  name: "OrderBy_AuctionSettleds",
  description: ?None,
  values: {
    "id": {GraphQLEnumType.value: "id", description: ?None, deprecationReason: ?None},
    "tokenId": {GraphQLEnumType.value: "tokenId", description: ?None, deprecationReason: ?None},
    "winner": {GraphQLEnumType.value: "winner", description: ?None, deprecationReason: ?None},
  }->makeEnumValues,
})
let enum_OrderBy_Auctions = GraphQLEnumType.make({
  name: "OrderBy_Auctions",
  description: ?None,
  values: {
    "id": {GraphQLEnumType.value: "id", description: ?None, deprecationReason: ?None},
    "tokenId": {GraphQLEnumType.value: "tokenId", description: ?None, deprecationReason: ?None},
    "blockTimestamp": {
      GraphQLEnumType.value: "blockTimestamp",
      description: ?None,
      deprecationReason: ?None,
    },
    "amount": {GraphQLEnumType.value: "amount", description: ?None, deprecationReason: ?None},
  }->makeEnumValues,
})
let enum_OrderBy_Questions = GraphQLEnumType.make({
  name: "OrderBy_Questions",
  description: ?None,
  values: {
    "id": {GraphQLEnumType.value: "id", description: ?None, deprecationReason: ?None},
    "tokenId": {GraphQLEnumType.value: "tokenId", description: ?None, deprecationReason: ?None},
  }->makeEnumValues,
})
let enum_OrderBy_Transfers = GraphQLEnumType.make({
  name: "OrderBy_Transfers",
  description: ?None,
  values: {
    "id": {GraphQLEnumType.value: "id", description: ?None, deprecationReason: ?None},
    "tokenId": {GraphQLEnumType.value: "tokenId", description: ?None, deprecationReason: ?None},
    "winner": {GraphQLEnumType.value: "winner", description: ?None, deprecationReason: ?None},
    "blockNumber": {
      GraphQLEnumType.value: "blockNumber",
      description: ?None,
      deprecationReason: ?None,
    },
  }->makeEnumValues,
})
let enum_OrderBy_Votes = GraphQLEnumType.make({
  name: "OrderBy_Votes",
  description: ?None,
  values: {
    "id": {GraphQLEnumType.value: "id", description: ?None, deprecationReason: ?None},
    "owner": {GraphQLEnumType.value: "owner", description: ?None, deprecationReason: ?None},
  }->makeEnumValues,
})
let enum_OrderDirection = GraphQLEnumType.make({
  name: "OrderDirection",
  description: ?None,
  values: {
    "asc": {GraphQLEnumType.value: "asc", description: ?None, deprecationReason: ?None},
    "desc": {GraphQLEnumType.value: "desc", description: ?None, deprecationReason: ?None},
  }->makeEnumValues,
})
let enum_SubgraphError = GraphQLEnumType.make({
  name: "SubgraphError",
  description: ?None,
  values: {
    "allow": {GraphQLEnumType.value: "allow", description: ?None, deprecationReason: ?None},
    "deny": {GraphQLEnumType.value: "deny", description: ?None, deprecationReason: ?None},
  }->makeEnumValues,
})
let i_Node: ref<GraphQLInterfaceType.t> = Obj.magic({"contents": Js.null})
let get_Node = () => i_Node.contents
let t_Answer: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_Answer = () => t_Answer.contents
let t_AnswerConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AnswerConnection = () => t_AnswerConnection.contents
let t_AnswerEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AnswerEdge = () => t_AnswerEdge.contents
let t_Auction: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_Auction = () => t_Auction.contents
let t_AuctionBid: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionBid = () => t_AuctionBid.contents
let t_AuctionBidConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionBidConnection = () => t_AuctionBidConnection.contents
let t_AuctionBidEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionBidEdge = () => t_AuctionBidEdge.contents
let t_AuctionConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionConnection = () => t_AuctionConnection.contents
let t_AuctionContract: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionContract = () => t_AuctionContract.contents
let t_AuctionCreated: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionCreated = () => t_AuctionCreated.contents
let t_AuctionCreatedConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionCreatedConnection = () => t_AuctionCreatedConnection.contents
let t_AuctionCreatedEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionCreatedEdge = () => t_AuctionCreatedEdge.contents
let t_AuctionEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionEdge = () => t_AuctionEdge.contents
let t_AuctionSettled: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionSettled = () => t_AuctionSettled.contents
let t_AuctionSettledConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionSettledConnection = () => t_AuctionSettledConnection.contents
let t_AuctionSettledEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionSettledEdge = () => t_AuctionSettledEdge.contents
let t_Error: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_Error = () => t_Error.contents
let t_PageInfo: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_PageInfo = () => t_PageInfo.contents
let t_Query: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_Query = () => t_Query.contents
let t_Question: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_Question = () => t_Question.contents
let t_QuestionConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_QuestionConnection = () => t_QuestionConnection.contents
let t_QuestionEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_QuestionEdge = () => t_QuestionEdge.contents
let t_QuestionOption: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_QuestionOption = () => t_QuestionOption.contents
let t_QuestionSubmitted: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_QuestionSubmitted = () => t_QuestionSubmitted.contents
let t_QuestionSubmittedConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_QuestionSubmittedConnection = () => t_QuestionSubmittedConnection.contents
let t_QuestionSubmittedEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_QuestionSubmittedEdge = () => t_QuestionSubmittedEdge.contents
let t_TextQuestion: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_TextQuestion = () => t_TextQuestion.contents
let t_TriviaQuestion: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_TriviaQuestion = () => t_TriviaQuestion.contents
let t_TriviaQuestionConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_TriviaQuestionConnection = () => t_TriviaQuestionConnection.contents
let t_TriviaQuestionEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_TriviaQuestionEdge = () => t_TriviaQuestionEdge.contents
let t_VerificationData: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_VerificationData = () => t_VerificationData.contents
let t_VerificationsData: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_VerificationsData = () => t_VerificationsData.contents
let t_Vote: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_Vote = () => t_Vote.contents
let t_VoteConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_VoteConnection = () => t_VoteConnection.contents
let t_VoteContract: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_VoteContract = () => t_VoteContract.contents
let t_VoteEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_VoteEdge = () => t_VoteEdge.contents
let t_VoteTransfer: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_VoteTransfer = () => t_VoteTransfer.contents
let t_VoteTransferConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_VoteTransferConnection = () => t_VoteTransferConnection.contents
let t_VoteTransferEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_VoteTransferEdge = () => t_VoteTransferEdge.contents
let input_Where_AuctionBids: ref<GraphQLInputObjectType.t> = Obj.magic({"contents": Js.null})
let get_Where_AuctionBids = () => input_Where_AuctionBids.contents
let input_Where_AuctionBids_conversionInstructions = []
let input_Where_AuctionCreateds: ref<GraphQLInputObjectType.t> = Obj.magic({"contents": Js.null})
let get_Where_AuctionCreateds = () => input_Where_AuctionCreateds.contents
let input_Where_AuctionCreateds_conversionInstructions = []
let input_Where_Auctions: ref<GraphQLInputObjectType.t> = Obj.magic({"contents": Js.null})
let get_Where_Auctions = () => input_Where_Auctions.contents
let input_Where_Auctions_conversionInstructions = []
let input_Where_Questions: ref<GraphQLInputObjectType.t> = Obj.magic({"contents": Js.null})
let get_Where_Questions = () => input_Where_Questions.contents
let input_Where_Questions_conversionInstructions = []
let input_Where_Transfers: ref<GraphQLInputObjectType.t> = Obj.magic({"contents": Js.null})
let get_Where_Transfers = () => input_Where_Transfers.contents
let input_Where_Transfers_conversionInstructions = []
let input_Where_Votes: ref<GraphQLInputObjectType.t> = Obj.magic({"contents": Js.null})
let get_Where_Votes = () => input_Where_Votes.contents
let input_Where_Votes_conversionInstructions = []
input_Where_AuctionBids_conversionInstructions->Array.pushMany([
  ("id", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
  ("tokenId", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
])
input_Where_AuctionCreateds_conversionInstructions->Array.pushMany([
  ("id", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
  ("tokenId", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
])
input_Where_Auctions_conversionInstructions->Array.pushMany([
  ("id", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
  ("tokenId", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
])
input_Where_Questions_conversionInstructions->Array.pushMany([
  ("id", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
  ("tokenId", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
])
input_Where_Transfers_conversionInstructions->Array.pushMany([
  ("id", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
  ("tokenId", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
  ("from", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
])
input_Where_Votes_conversionInstructions->Array.pushMany([
  ("id", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
  ("owner", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
  ("tokenId_in", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
])
let union_Verification: ref<GraphQLUnionType.t> = Obj.magic({"contents": Js.null})
let get_Verification = () => union_Verification.contents
let union_Verifications: ref<GraphQLUnionType.t> = Obj.magic({"contents": Js.null})
let get_Verifications = () => union_Verifications.contents

let union_Verification_resolveType = (v: Verification.verification) =>
  switch v {
  | Verification(_) => "VerificationData"
  | BrightIdError(_) => "Error"
  }

let union_Verifications_resolveType = (v: Verifications.verifications) =>
  switch v {
  | Verifications(_) => "VerificationsData"
  | BrightIdError(_) => "Error"
  }

let interface_Node_resolveType = (v: Interface_node.Resolver.t) =>
  switch v {
  | AuctionContract(_) => "AuctionContract"
  | VoteTransfer(_) => "VoteTransfer"
  | AuctionBid(_) => "AuctionBid"
  | Auction(_) => "Auction"
  | AuctionSettled(_) => "AuctionSettled"
  | VoteContract(_) => "VoteContract"
  | AuctionCreated(_) => "AuctionCreated"
  | VerificationData(_) => "VerificationData"
  | TriviaQuestion(_) => "TriviaQuestion"
  | Question(_) => "Question"
  | QuestionSubmitted(_) => "QuestionSubmitted"
  | Vote(_) => "Vote"
  | Answer(_) => "Answer"
  | VerificationsData(_) => "VerificationsData"
  }

i_Node.contents = GraphQLInterfaceType.make({
  name: "Node",
  description: "An object with an ID.",
  interfaces: [],
  fields: () =>
    {
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
      },
    }->makeFields,
  resolveType: GraphQLInterfaceType.makeResolveInterfaceTypeFn(interface_Node_resolveType),
})
t_Answer.contents = GraphQLObjectType.make({
  name: "Answer",
  description: ?None,
  interfaces: [get_Node()],
  fields: () =>
    {
      "answerNumByUser": {
        typ: Scalars.int->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["answerNumByUser"]
        }),
      },
      "day": {
        typ: Scalars.int->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["day"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=Answer)
        }),
      },
      "option": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["option"]
        }),
      },
      "user": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "The user that submitted the answer",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["user"]
        }),
      },
    }->makeFields,
})
t_AnswerConnection.contents = GraphQLObjectType.make({
  name: "AnswerConnection",
  description: "A connection to an auction.",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_AnswerEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_AnswerEdge.contents = GraphQLObjectType.make({
  name: "AnswerEdge",
  description: "An edge to an auction.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_Answer()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
t_Auction.contents = GraphQLObjectType.make({
  name: "Auction",
  description: ?None,
  interfaces: [get_Node()],
  fields: () =>
    {
      "amount": {
        typ: scalar_BigInt->GraphQLScalar.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionResolvers.amount(src)
        }),
      },
      "bidder": {
        typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["bidder"]
        }),
      },
      "bids": {
        typ: get_AuctionBidConnection()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_AuctionBids->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "where": {typ: get_Where_AuctionBids()->GraphQLInputObjectType.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionResolvers.bids(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~ctx,
            ~first=args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=args["orderBy"]->Nullable.toOption,
            ~orderDirection=args["orderDirection"]->Nullable.toOption,
            ~where=switch args["where"]->Nullable.toOption {
            | None => None
            | Some(v) =>
              v->applyConversionToInputObject(input_Where_AuctionBids_conversionInstructions)->Some
            },
          )
        }),
      },
      "contract": {
        typ: get_AuctionContract()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionResolvers.contract(src, ~ctx)
        }),
      },
      "endTime": {
        typ: scalar_Timestamp->GraphQLScalar.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionResolvers.endTime(src)
        }),
      },
      "extended": {
        typ: Scalars.boolean->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["extended"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=Auction)
        }),
      },
      "settled": {
        typ: Scalars.boolean->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["settled"]
        }),
      },
      "startTime": {
        typ: scalar_Timestamp->GraphQLScalar.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionResolvers.startTime(src)
        }),
      },
      "tokenId": {
        typ: scalar_BigInt->GraphQLScalar.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionResolvers.tokenId(src)
        }),
      },
      "vote": {
        typ: get_Vote()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionResolvers.vote(src, ~ctx)
        }),
      },
    }->makeFields,
})
t_AuctionBid.contents = GraphQLObjectType.make({
  name: "AuctionBid",
  description: "GraphClient: A bid on a Vote Auction",
  interfaces: [get_Node()],
  fields: () =>
    {
      "amount": {
        typ: scalar_BigInt->GraphQLScalar.toGraphQLType->nonNull,
        description: "The amount of the bid",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionBidResolvers.amount(src)
        }),
      },
      "bidder": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "The address of the bidder",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["bidder"]
        }),
      },
      "blockTimestamp": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "The time the bid was made",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["blockTimestamp"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=AuctionBid)
        }),
      },
      "tokenId": {
        typ: scalar_BigInt->GraphQLScalar.toGraphQLType->nonNull,
        description: "The ID of the Vote Token",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionBidResolvers.tokenId(src)
        }),
      },
    }->makeFields,
})
t_AuctionBidConnection.contents = GraphQLObjectType.make({
  name: "AuctionBidConnection",
  description: "A connection of auction bids.",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_AuctionBidEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_AuctionBidEdge.contents = GraphQLObjectType.make({
  name: "AuctionBidEdge",
  description: "An edge to an auction bid.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_AuctionBid()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
t_AuctionConnection.contents = GraphQLObjectType.make({
  name: "AuctionConnection",
  description: "A connection to an auction.",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_AuctionEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_AuctionContract.contents = GraphQLObjectType.make({
  name: "AuctionContract",
  description: ?None,
  interfaces: [get_Node()],
  fields: () =>
    {
      "auctions": {
        typ: get_AuctionConnection()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_Auctions->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "where": {typ: get_Where_Auctions()->GraphQLInputObjectType.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionContractResolvers.auctions(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~ctx,
            ~first=args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=args["orderBy"]->Nullable.toOption,
            ~orderDirection=args["orderDirection"]->Nullable.toOption,
            ~where=switch args["where"]->Nullable.toOption {
            | None => None
            | Some(v) =>
              v->applyConversionToInputObject(input_Where_Auctions_conversionInstructions)->Some
            },
          )
        }),
      },
      "duration": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["duration"]
        }),
      },
      "flashVotesURI": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["flashVotesURI"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=AuctionContract)
        }),
      },
      "launched": {
        typ: Scalars.boolean->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["launched"]
        }),
      },
      "minBidIncrement": {
        typ: scalar_BigInt->GraphQLScalar.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionContractResolvers.minBidIncrement(src)
        }),
      },
      "paused": {
        typ: Scalars.boolean->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["paused"]
        }),
      },
      "raffleAddress": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["raffleAddress"]
        }),
      },
      "reserveAddress": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["reserveAddress"]
        }),
      },
      "reservePrice": {
        typ: scalar_BigInt->GraphQLScalar.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionContractResolvers.reservePrice(src)
        }),
      },
      "timeBuffer": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["timeBuffer"]
        }),
      },
      "treasury": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["treasury"]
        }),
      },
      "votesToken": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["votesToken"]
        }),
      },
      "votesURI": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["votesURI"]
        }),
      },
    }->makeFields,
})
t_AuctionCreated.contents = GraphQLObjectType.make({
  name: "AuctionCreated",
  description: "GraphClient: A Votes Auction",
  interfaces: [get_Node()],
  fields: () =>
    {
      "endTime": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "End time of auction *",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["endTime"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=AuctionCreated)
        }),
      },
      "startTime": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "Start time of auction *",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["startTime"]
        }),
      },
      "tokenId": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "ID of Votes token *",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["tokenId"]
        }),
      },
    }->makeFields,
})
t_AuctionCreatedConnection.contents = GraphQLObjectType.make({
  name: "AuctionCreatedConnection",
  description: "A connection to a todo.",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_AuctionCreatedEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_AuctionCreatedEdge.contents = GraphQLObjectType.make({
  name: "AuctionCreatedEdge",
  description: "An edge to an auction.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_AuctionCreated()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
t_AuctionEdge.contents = GraphQLObjectType.make({
  name: "AuctionEdge",
  description: "An edge to an auction.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_Auction()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
t_AuctionSettled.contents = GraphQLObjectType.make({
  name: "AuctionSettled",
  description: "GraphClient: A Settled Votes Auction",
  interfaces: [get_Node()],
  fields: () =>
    {
      "amount": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "Amount of winning bid *",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["amount"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=AuctionSettled)
        }),
      },
      "tokenId": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "ID of Votes token *",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["tokenId"]
        }),
      },
      "winner": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "Winner of auction",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["winner"]
        }),
      },
    }->makeFields,
})
t_AuctionSettledConnection.contents = GraphQLObjectType.make({
  name: "AuctionSettledConnection",
  description: "A connection to a todo.",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_AuctionSettledEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_AuctionSettledEdge.contents = GraphQLObjectType.make({
  name: "AuctionSettledEdge",
  description: "An edge to a settledAuction.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_AuctionSettled()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
t_Error.contents = GraphQLObjectType.make({
  name: "Error",
  description: "BrightID Error object",
  interfaces: [],
  fields: () =>
    {
      "code": {
        typ: Scalars.int->Scalars.toGraphQLType->nonNull,
        description: "The error code",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["code"]
        }),
      },
      "error": {
        typ: Scalars.boolean->Scalars.toGraphQLType->nonNull,
        description: "Returns true if response is an error",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["error"]
        }),
      },
      "errorMessage": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "The error message",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["errorMessage"]
        }),
      },
      "errorNum": {
        typ: Scalars.int->Scalars.toGraphQLType->nonNull,
        description: "The error number",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["errorNum"]
        }),
      },
    }->makeFields,
})
t_PageInfo.contents = GraphQLObjectType.make({
  name: "PageInfo",
  description: "Information about pagination in a connection.",
  interfaces: [],
  fields: () =>
    {
      "endCursor": {
        typ: Scalars.string->Scalars.toGraphQLType,
        description: "When paginating forwards, the cursor to continue.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["endCursor"]
        }),
      },
      "hasNextPage": {
        typ: Scalars.boolean->Scalars.toGraphQLType->nonNull,
        description: "When paginating forwards, are there more items?",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["hasNextPage"]
        }),
      },
      "hasPreviousPage": {
        typ: Scalars.boolean->Scalars.toGraphQLType->nonNull,
        description: "When paginating backwards, are there more items?",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["hasPreviousPage"]
        }),
      },
      "startCursor": {
        typ: Scalars.string->Scalars.toGraphQLType,
        description: "When paginating backwards, the cursor to continue.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["startCursor"]
        }),
      },
    }->makeFields,
})
t_Query.contents = GraphQLObjectType.make({
  name: "Query",
  description: ?None,
  interfaces: [],
  fields: () =>
    {
      "answer": {
        typ: get_Answer()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          Answer.answer(src)
        }),
      },
      "auction": {
        typ: get_Auction()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionResolvers.auction(src, ~ctx, ~id=args["id"])
        }),
      },
      "auctionBid": {
        typ: get_AuctionBid()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionBidResolvers.auctionBid(src, ~ctx, ~id=args["id"])
        }),
      },
      "auctionBids": {
        typ: get_AuctionBidConnection()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_AuctionBids->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "where": {typ: get_Where_AuctionBids()->GraphQLInputObjectType.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionBidResolvers.auctionBids(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~ctx,
            ~first=args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=args["orderBy"]->Nullable.toOption,
            ~orderDirection=args["orderDirection"]->Nullable.toOption,
            ~where=switch args["where"]->Nullable.toOption {
            | None => None
            | Some(v) =>
              v->applyConversionToInputObject(input_Where_AuctionBids_conversionInstructions)->Some
            },
          )
        }),
      },
      "auctionContract": {
        typ: get_AuctionContract()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionContractResolvers.auctionContract(src, ~ctx, ~id=args["id"])
        }),
      },
      "auctionCreated": {
        typ: get_AuctionCreated()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionCreatedResolvers.Node.auctionCreated(src, ~ctx, ~id=args["id"])
        }),
      },
      "auctionCreateds": {
        typ: get_AuctionCreatedConnection()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_AuctionCreateds->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "skip": {typ: Scalars.int->Scalars.toGraphQLType},
          "where": {typ: get_Where_AuctionCreateds()->GraphQLInputObjectType.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionCreatedResolvers.Connection.auctionCreateds(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~first=args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=args["orderBy"]->Nullable.toOption,
            ~orderDirection=args["orderDirection"]->Nullable.toOption,
            ~skip=args["skip"]->Nullable.toOption,
            ~where=switch args["where"]->Nullable.toOption {
            | None => None
            | Some(v) =>
              v
              ->applyConversionToInputObject(input_Where_AuctionCreateds_conversionInstructions)
              ->Some
            },
          )
        }),
      },
      "auctionSettled": {
        typ: get_AuctionSettled()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionSettledResolvers.Node.auctionSettled(src, ~ctx, ~id=args["id"])
        }),
      },
      "auctionSettleds": {
        typ: get_AuctionSettledConnection()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_AuctionSettleds->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "skip": {typ: Scalars.int->Scalars.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionSettledResolvers.Connection.auctionSettleds(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~first=args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=args["orderBy"]->Nullable.toOption,
            ~orderDirection=args["orderDirection"]->Nullable.toOption,
            ~skip=args["skip"]->Nullable.toOption,
          )
        }),
      },
      "auctions": {
        typ: get_AuctionConnection()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_Auctions->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "where": {typ: get_Where_Auctions()->GraphQLInputObjectType.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          AuctionResolvers.auctions(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~ctx,
            ~first=args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=args["orderBy"]->Nullable.toOption,
            ~orderDirection=args["orderDirection"]->Nullable.toOption,
            ~where=switch args["where"]->Nullable.toOption {
            | None => None
            | Some(v) =>
              v->applyConversionToInputObject(input_Where_Auctions_conversionInstructions)->Some
            },
          )
        }),
      },
      "newestVote": {
        typ: get_Vote()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "voteContractAddress": {typ: Scalars.string->Scalars.toGraphQLType->nonNull},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteResolvers.newestVote(src, ~ctx, ~voteContractAddress=args["voteContractAddress"])
        }),
      },
      "node": {
        typ: get_Node()->GraphQLInterfaceType.toGraphQLType,
        description: "Fetches an object given its ID.",
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.id->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.node(src, ~ctx, ~id=args["id"])
        }),
      },
      "nodes": {
        typ: GraphQLListType.make(get_Node()->GraphQLInterfaceType.toGraphQLType)
        ->GraphQLListType.toGraphQLType
        ->nonNull,
        description: "Fetches objects given their IDs.",
        deprecationReason: ?None,
        args: {
          "ids": {
            typ: GraphQLListType.make(Scalars.id->Scalars.toGraphQLType->nonNull)
            ->GraphQLListType.toGraphQLType
            ->nonNull,
          },
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.nodes(src, ~ctx, ~ids=args["ids"])
        }),
      },
      "question": {
        typ: get_Question()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          QuestionResolvers.question(src, ~ctx, ~id=args["id"])
        }),
      },
      "questionSubmitted": {
        typ: get_QuestionSubmitted()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          QuestionSubmittedResolvers.Node.questionSubmitted(src, ~ctx, ~id=args["id"])
        }),
      },
      "questionSubmitteds": {
        typ: get_QuestionSubmittedConnection()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "skip": {typ: Scalars.int->Scalars.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          QuestionSubmittedResolvers.Connection.questionSubmitteds(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~first=args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~skip=args["skip"]->Nullable.toOption,
          )
        }),
      },
      "questions": {
        typ: get_QuestionConnection()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_Questions->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "where": {typ: get_Where_Questions()->GraphQLInputObjectType.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          QuestionResolvers.questions(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~ctx,
            ~first=args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=args["orderBy"]->Nullable.toOption,
            ~orderDirection=args["orderDirection"]->Nullable.toOption,
            ~where=switch args["where"]->Nullable.toOption {
            | None => None
            | Some(v) =>
              v->applyConversionToInputObject(input_Where_Questions_conversionInstructions)->Some
            },
          )
        }),
      },
      "raffles": {
        typ: get_VoteConnection()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_Votes->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "skip": {typ: Scalars.int->Scalars.toGraphQLType},
          "votesContractAddress": {typ: Scalars.string->Scalars.toGraphQLType->nonNull},
          "where": {typ: get_Where_Votes()->GraphQLInputObjectType.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteResolvers.raffles(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~ctx,
            ~first=?args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=?args["orderBy"]->Nullable.toOption,
            ~orderDirection=?args["orderDirection"]->Nullable.toOption,
            ~skip=?args["skip"]->Nullable.toOption,
            ~votesContractAddress=args["votesContractAddress"],
            ~where=?switch args["where"]->Nullable.toOption {
            | None => None
            | Some(v) =>
              v->applyConversionToInputObject(input_Where_Votes_conversionInstructions)->Some
            },
          )
        }),
      },
      "randomQuestion": {
        typ: get_TriviaQuestion()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          TriviaQuestionResolvers.randomQuestion(src, ~ctx)
        }),
      },
      "randomQuestions": {
        typ: get_TriviaQuestionConnection()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "limit": {typ: Scalars.int->Scalars.toGraphQLType->nonNull},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          TriviaQuestionResolvers.randomQuestions(
            src,
            ~after=?args["after"]->Nullable.toOption,
            ~before=?args["before"]->Nullable.toOption,
            ~ctx,
            ~first=?args["first"]->Nullable.toOption,
            ~last=?args["last"]->Nullable.toOption,
            ~limit=args["limit"],
          )
        }),
      },
      "triviaQuestionById": {
        typ: get_TriviaQuestion()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          TriviaQuestionResolvers.triviaQuestionById(src, ~ctx, ~id=args["id"])
        }),
      },
      "verification": {
        typ: get_Verification()->GraphQLUnionType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        args: {"contextId": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VerificationResolvers.verification(src, ~contextId=args["contextId"], ~ctx)
        }),
      },
      "verifications": {
        typ: get_Verifications()->GraphQLUnionType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        args: {"context": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VerificationsResolver.verifications(src, ~context=args["context"], ~ctx)
        }),
      },
      "vote": {
        typ: get_Vote()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteResolvers.vote(src, ~ctx, ~id=args["id"])
        }),
      },
      "voteContract": {
        typ: get_VoteContract()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteContractResolvers.voteContract(src, ~ctx, ~id=args["id"])
        }),
      },
      "voteTransfer": {
        typ: get_VoteTransfer()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {"id": {typ: Scalars.string->Scalars.toGraphQLType->nonNull}}->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteTransferResolvers.Node.voteTransfer(src, ~ctx, ~id=args["id"])
        }),
      },
      "voteTransfers": {
        typ: get_VoteTransferConnection()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_Transfers->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "skip": {typ: Scalars.int->Scalars.toGraphQLType},
          "where": {typ: get_Where_Transfers()->GraphQLInputObjectType.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteTransferResolvers.Connection.voteTransfers(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~first=args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=args["orderBy"]->Nullable.toOption,
            ~orderDirection=args["orderDirection"]->Nullable.toOption,
            ~skip=args["skip"]->Nullable.toOption,
            ~where=switch args["where"]->Nullable.toOption {
            | None => None
            | Some(v) =>
              v->applyConversionToInputObject(input_Where_Transfers_conversionInstructions)->Some
            },
          )
        }),
      },
      "votes": {
        typ: get_VoteConnection()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        args: {
          "after": {typ: Scalars.string->Scalars.toGraphQLType},
          "before": {typ: Scalars.string->Scalars.toGraphQLType},
          "first": {typ: Scalars.int->Scalars.toGraphQLType},
          "last": {typ: Scalars.int->Scalars.toGraphQLType},
          "orderBy": {typ: enum_OrderBy_Votes->GraphQLEnumType.toGraphQLType},
          "orderDirection": {typ: enum_OrderDirection->GraphQLEnumType.toGraphQLType},
          "skip": {typ: Scalars.int->Scalars.toGraphQLType},
          "where": {typ: get_Where_Votes()->GraphQLInputObjectType.toGraphQLType},
        }->makeArgs,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteResolvers.votes(
            src,
            ~after=args["after"]->Nullable.toOption,
            ~before=args["before"]->Nullable.toOption,
            ~ctx,
            ~first=?args["first"]->Nullable.toOption,
            ~last=args["last"]->Nullable.toOption,
            ~orderBy=?args["orderBy"]->Nullable.toOption,
            ~orderDirection=?args["orderDirection"]->Nullable.toOption,
            ~skip=?args["skip"]->Nullable.toOption,
            ~where=?switch args["where"]->Nullable.toOption {
            | None => None
            | Some(v) =>
              v->applyConversionToInputObject(input_Where_Votes_conversionInstructions)->Some
            },
          )
        }),
      },
    }->makeFields,
})
t_Question.contents = GraphQLObjectType.make({
  name: "Question",
  description: ?None,
  interfaces: [get_Node()],
  fields: () =>
    {
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=Question)
        }),
      },
      "isLocked": {
        typ: Scalars.boolean->Scalars.toGraphQLType->nonNull,
        description: "If question has been locked by curator",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["isLocked"]
        }),
      },
      "options": {
        typ: GraphQLListType.make(get_QuestionOption()->GraphQLObjectType.toGraphQLType->nonNull)
        ->GraphQLListType.toGraphQLType
        ->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          QuestionResolvers.options(src, ~ctx)
        }),
      },
      "title": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "The question",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          QuestionResolvers.title(src, ~ctx)
        }),
      },
      "tokenId": {
        typ: scalar_BigInt->GraphQLScalar.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          QuestionResolvers.tokenId(src)
        }),
      },
    }->makeFields,
})
t_QuestionConnection.contents = GraphQLObjectType.make({
  name: "QuestionConnection",
  description: "A connection of questions.",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_QuestionEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_QuestionEdge.contents = GraphQLObjectType.make({
  name: "QuestionEdge",
  description: "An edge to a question.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_Question()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
t_QuestionOption.contents = GraphQLObjectType.make({
  name: "QuestionOption",
  description: ?None,
  interfaces: [],
  fields: () =>
    {
      "details": {
        typ: Scalars.string->Scalars.toGraphQLType,
        description: "The id of the option",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["details"]
        }),
      },
      "option": {
        typ: Scalars.string->Scalars.toGraphQLType,
        description: "The text of the option",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["option"]
        }),
      },
    }->makeFields,
})
t_QuestionSubmitted.contents = GraphQLObjectType.make({
  name: "QuestionSubmitted",
  description: ?None,
  interfaces: [get_Node()],
  fields: () =>
    {
      "answerNum": {
        typ: Scalars.int->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["answerNum"]
        }),
      },
      "answers": {
        typ: GraphQLListType.make(
          Scalars.string->Scalars.toGraphQLType->nonNull,
        )->GraphQLListType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["answers"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=QuestionSubmitted)
        }),
      },
      "options": {
        typ: GraphQLListType.make(Scalars.string->Scalars.toGraphQLType->nonNull)
        ->GraphQLListType.toGraphQLType
        ->nonNull,
        description: "Answer options for the question",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["options"]
        }),
      },
      "question": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "Question asked",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["question"]
        }),
      },
      "tokenId": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "ID of the vote token attached to the question. If the community vote is\n  used this will be the zero address",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["tokenId"]
        }),
      },
    }->makeFields,
})
t_QuestionSubmittedConnection.contents = GraphQLObjectType.make({
  name: "QuestionSubmittedConnection",
  description: "A connection to a todo.",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_QuestionSubmittedEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_QuestionSubmittedEdge.contents = GraphQLObjectType.make({
  name: "QuestionSubmittedEdge",
  description: "An edge to a submitted Question.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_QuestionSubmitted()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
t_TextQuestion.contents = GraphQLObjectType.make({
  name: "TextQuestion",
  description: ?None,
  interfaces: [],
  fields: () =>
    {
      "text": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["text"]
        }),
      },
    }->makeFields,
})
t_TriviaQuestion.contents = GraphQLObjectType.make({
  name: "TriviaQuestion",
  description: ?None,
  interfaces: [get_Node()],
  fields: () =>
    {
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=TriviaQuestion)
        }),
      },
      "options": {
        typ: GraphQLListType.make(Scalars.string->Scalars.toGraphQLType->nonNull)
        ->GraphQLListType.toGraphQLType
        ->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          TriviaQuestionResolvers.options(src, ~ctx)
        }),
      },
      "question": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          TriviaQuestionResolvers.question(src, ~ctx)
        }),
      },
    }->makeFields,
})
t_TriviaQuestionConnection.contents = GraphQLObjectType.make({
  name: "TriviaQuestionConnection",
  description: "A connection of trivia questions.",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_TriviaQuestionEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_TriviaQuestionEdge.contents = GraphQLObjectType.make({
  name: "TriviaQuestionEdge",
  description: "An edge to a trivia question.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_TriviaQuestion()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
t_VerificationData.contents = GraphQLObjectType.make({
  name: "VerificationData",
  description: "Data fields from a verified contextID",
  interfaces: [get_Node()],
  fields: () =>
    {
      "app": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "the key of app",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["app"]
        }),
      },
      "context": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "The context the contextID is linked to. This should always be Votes",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["context"]
        }),
      },
      "contextIds": {
        typ: GraphQLListType.make(Scalars.string->Scalars.toGraphQLType->nonNull)
        ->GraphQLListType.toGraphQLType
        ->nonNull,
        description: "Array of ids linked to the Votes context",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["contextIds"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=VerificationData)
        }),
      },
      "publicKey": {
        typ: Scalars.string->Scalars.toGraphQLType,
        description: "The public key of the verification",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["publicKey"]
        }),
      },
      "sig": {
        typ: Scalars.string->Scalars.toGraphQLType,
        description: "The signature of the verification",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["sig"]
        }),
      },
      "timestamp": {
        typ: Scalars.float->Scalars.toGraphQLType,
        description: "The timestamp of the verification",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["timestamp"]
        }),
      },
      "unique": {
        typ: Scalars.boolean->Scalars.toGraphQLType->nonNull,
        description: "Bool value denoting whether the BrightID is owned by a unique human",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["unique"]
        }),
      },
    }->makeFields,
})
t_VerificationsData.contents = GraphQLObjectType.make({
  name: "VerificationsData",
  description: ?None,
  interfaces: [get_Node()],
  fields: () =>
    {
      "contextIds": {
        typ: GraphQLListType.make(Scalars.string->Scalars.toGraphQLType->nonNull)
        ->GraphQLListType.toGraphQLType
        ->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["contextIds"]
        }),
      },
      "count": {
        typ: Scalars.int->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["count"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=VerificationsData)
        }),
      },
    }->makeFields,
})
t_Vote.contents = GraphQLObjectType.make({
  name: "Vote",
  description: "GraphClient: A Vote Token entity",
  interfaces: [get_Node()],
  fields: () =>
    {
      "auction": {
        typ: get_Auction()->GraphQLObjectType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteResolvers.auction(src, ~ctx)
        }),
      },
      "contract": {
        typ: get_VoteContract()->GraphQLObjectType.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteResolvers.contract(src, ~ctx)
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=Vote)
        }),
      },
      "owner": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["owner"]
        }),
      },
      "tokenId": {
        typ: scalar_BigInt->GraphQLScalar.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteResolvers.tokenId(src)
        }),
      },
      "uri": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["uri"]
        }),
      },
    }->makeFields,
})
t_VoteConnection.contents = GraphQLObjectType.make({
  name: "VoteConnection",
  description: "A connection of votes .",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_VoteEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_VoteContract.contents = GraphQLObjectType.make({
  name: "VoteContract",
  description: "GraphClient: A Vote Contract entity",
  interfaces: [get_Node()],
  fields: () =>
    {
      "address": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteContractResolvers.address(src)
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=VoteContract)
        }),
      },
      "name": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["name"]
        }),
      },
      "symbol": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["symbol"]
        }),
      },
      "totalSupply": {
        typ: scalar_BigInt->GraphQLScalar.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          VoteContractResolvers.totalSupply(src)
        }),
      },
    }->makeFields,
})
t_VoteEdge.contents = GraphQLObjectType.make({
  name: "VoteEdge",
  description: "An edge to a vote entity.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_Vote()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
t_VoteTransfer.contents = GraphQLObjectType.make({
  name: "VoteTransfer",
  description: "GraphClient: A Transfer Event for a Vote token",
  interfaces: [get_Node()],
  fields: () =>
    {
      "blockNumber": {
        typ: Scalars.int->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["blockNumber"]
        }),
      },
      "id": {
        typ: Scalars.id->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, args, ctx) => {
          let src = typeUnwrapper(src)
          NodeInterfaceResolvers.id(src, ~typename=VoteTransfer)
        }),
      },
      "to": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["to"]
        }),
      },
      "tokenId": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["tokenId"]
        }),
      },
      "transactionHash": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["transactionHash"]
        }),
      },
    }->makeFields,
})
t_VoteTransferConnection.contents = GraphQLObjectType.make({
  name: "VoteTransferConnection",
  description: "A connection to a vote transfer.",
  interfaces: [],
  fields: () =>
    {
      "edges": {
        typ: GraphQLListType.make(
          get_VoteTransferEdge()->GraphQLObjectType.toGraphQLType,
        )->GraphQLListType.toGraphQLType,
        description: "A list of edges.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["edges"]
        }),
      },
      "pageInfo": {
        typ: get_PageInfo()->GraphQLObjectType.toGraphQLType->nonNull,
        description: "Information to aid in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["pageInfo"]
        }),
      },
    }->makeFields,
})
t_VoteTransferEdge.contents = GraphQLObjectType.make({
  name: "VoteTransferEdge",
  description: "An edge to a vote transfer event.",
  interfaces: [],
  fields: () =>
    {
      "cursor": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: "A cursor for use in pagination.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["cursor"]
        }),
      },
      "node": {
        typ: get_VoteTransfer()->GraphQLObjectType.toGraphQLType,
        description: "The item at the end of the edge.",
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["node"]
        }),
      },
    }->makeFields,
})
input_Where_AuctionBids.contents = GraphQLInputObjectType.make({
  name: "Where_AuctionBids",
  description: ?None,
  fields: () =>
    {
      "id": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
      "tokenId": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
    }->makeFields,
})
input_Where_AuctionCreateds.contents = GraphQLInputObjectType.make({
  name: "Where_AuctionCreateds",
  description: ?None,
  fields: () =>
    {
      "id": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
      "tokenId": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
    }->makeFields,
})
input_Where_Auctions.contents = GraphQLInputObjectType.make({
  name: "Where_Auctions",
  description: ?None,
  fields: () =>
    {
      "id": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
      "tokenId": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
    }->makeFields,
})
input_Where_Questions.contents = GraphQLInputObjectType.make({
  name: "Where_Questions",
  description: ?None,
  fields: () =>
    {
      "id": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
      "tokenId": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
    }->makeFields,
})
input_Where_Transfers.contents = GraphQLInputObjectType.make({
  name: "Where_Transfers",
  description: ?None,
  fields: () =>
    {
      "from": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
      "id": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
      "tokenId": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
    }->makeFields,
})
input_Where_Votes.contents = GraphQLInputObjectType.make({
  name: "Where_Votes",
  description: ?None,
  fields: () =>
    {
      "id": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
      "owner": {
        GraphQLInputObjectType.typ: Scalars.string->Scalars.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
      "tokenId_in": {
        GraphQLInputObjectType.typ: GraphQLListType.make(
          Scalars.string->Scalars.toGraphQLType->nonNull,
        )->GraphQLListType.toGraphQLType,
        description: ?None,
        deprecationReason: ?None,
      },
    }->makeFields,
})
union_Verification.contents = GraphQLUnionType.make({
  name: "Verification",
  description: ?None,
  types: () => [get_Error(), get_VerificationData()],
  resolveType: GraphQLUnionType.makeResolveUnionTypeFn(union_Verification_resolveType),
})
union_Verifications.contents = GraphQLUnionType.make({
  name: "Verifications",
  description: ?None,
  types: () => [get_Error(), get_VerificationsData()],
  resolveType: GraphQLUnionType.makeResolveUnionTypeFn(union_Verifications_resolveType),
})

let schema = GraphQLSchemaType.make({"query": get_Query()})
