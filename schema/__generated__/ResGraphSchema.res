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
    "price": {GraphQLEnumType.value: "price", description: ?None, deprecationReason: ?None},
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
let t_AuctionCreated: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionCreated = () => t_AuctionCreated.contents
let t_AuctionCreatedConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionCreatedConnection = () => t_AuctionCreatedConnection.contents
let t_AuctionCreatedEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionCreatedEdge = () => t_AuctionCreatedEdge.contents
let t_AuctionSettled: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionSettled = () => t_AuctionSettled.contents
let t_AuctionSettledConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionSettledConnection = () => t_AuctionSettledConnection.contents
let t_AuctionSettledEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_AuctionSettledEdge = () => t_AuctionSettledEdge.contents
let t_PageInfo: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_PageInfo = () => t_PageInfo.contents
let t_Query: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_Query = () => t_Query.contents
let t_QuestionSubmitted: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_QuestionSubmitted = () => t_QuestionSubmitted.contents
let t_QuestionSubmittedConnection: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_QuestionSubmittedConnection = () => t_QuestionSubmittedConnection.contents
let t_QuestionSubmittedEdge: ref<GraphQLObjectType.t> = Obj.magic({"contents": Js.null})
let get_QuestionSubmittedEdge = () => t_QuestionSubmittedEdge.contents
let input_Where_AuctionCreateds: ref<GraphQLInputObjectType.t> = Obj.magic({"contents": Js.null})
let get_Where_AuctionCreateds = () => input_Where_AuctionCreateds.contents
let input_Where_AuctionCreateds_conversionInstructions = []
input_Where_AuctionCreateds_conversionInstructions->Array.pushMany([
  ("id", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
  ("tokenId", makeInputObjectFieldConverterFn(v => v->Nullable.toOption)),
])

let interface_Node_resolveType = (v: Interface_node.Resolver.t) =>
  switch v {
  | AuctionSettled(_) => "AuctionSettled"
  | AuctionCreated(_) => "AuctionCreated"
  | QuestionSubmitted(_) => "QuestionSubmitted"
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
      "id": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
      },
    }->makeFields,
  resolveType: GraphQLInterfaceType.makeResolveInterfaceTypeFn(interface_Node_resolveType),
})
t_AuctionCreated.contents = GraphQLObjectType.make({
  name: "AuctionCreated",
  description: "GraphClient: A Votes Auction",
  interfaces: [get_Node()],
  fields: () =>
    {
      "id": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["id"]
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
t_AuctionSettled.contents = GraphQLObjectType.make({
  name: "AuctionSettled",
  description: "GraphClient: A Settled Votes Auction",
  interfaces: [get_Node()],
  fields: () =>
    {
      "id": {
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["id"]
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
        typ: Scalars.string->Scalars.toGraphQLType->nonNull,
        description: ?None,
        deprecationReason: ?None,
        resolve: makeResolveFn((src, _args, _ctx) => {
          let src = typeUnwrapper(src)
          src["id"]
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

let schema = GraphQLSchemaType.make({"query": get_Query()})
