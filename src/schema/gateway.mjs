import { buildHTTPExecutor } from '@graphql-tools/executor-http';
import { createMergedTypeResolver, stitchSchemas } from '@graphql-tools/stitch';
import { RenameInputObjectFields, RenameObjectFieldArguments, RenameRootTypes, TransformEnumValues, TransformInputObjectFields, TransformObjectFields, schemaFromExecutor } from '@graphql-tools/wrap';
import { delegateToSchema } from '@graphql-tools/delegate';
import { connectionFromArray, toGlobalId, fromGlobalId } from 'graphql-relay';
import { GraphQLNonNull, GraphQLScalarType } from 'graphql';

const relayCompatibleSchema =
/* GraphQL */ `
    extend type Query {
        questionConnection(
          first: Int
          offset: Int
          before: Cursor
          after: Cursor
          orderDirection: OrderDirection
          orderBy: Question_orderBy
          block: Block_height
          where:Question_filter
          subgraphError: _SubgraphErrorPolicy_! = deny
        ): QuestionConnection!

        voteConnection(
          first: Int
          offset: Int
          before: Cursor
          after: Cursor
          orderDirection: OrderDirection
          orderBy: Vote_orderBy
          block: Block_height
          where:Vote_filter
          subgraphError: _SubgraphErrorPolicy_! = deny
        ): VoteConnection!

        auctionConnection(
          first: Int
          offset: Int
          before: Cursor
          after: Cursor
          orderDirection: OrderDirection
          orderBy: Auction_orderBy
          block: Block_height
          where:Auction_filter
          subgraphError: _SubgraphErrorPolicy_! = deny
        ): AuctionConnection!

        auctionBidConnection(
          first: Int
          offset: Int
          before: Cursor
          after: Cursor
          orderDirection: OrderDirection
          orderBy: AuctionBid_orderBy
          block: Block_height
          where:AuctionBid_filter
          subgraphError: _SubgraphErrorPolicy_! = deny
        ): AuctionBidConnection!

    }

    type QuestionEdge {
      cursor: Cursor
      node: Question
    }

    type QuestionConnection {
      nodes: [Question]!
      edges: [QuestionEdge]!
      pageInfo: PageInfo!
    }

    type VoteEdge {
      cursor: Cursor
      node: Vote
    }

    type VoteConnection {
      nodes: [Vote]!
      edges: [VoteEdge]!
      pageInfo: PageInfo!
    }

    type AuctionEdge {
      cursor: Cursor
      node: Auction
    }

    type AuctionConnection {
      nodes: [Auction]!
      edges: [AuctionEdge]!
      pageInfo: PageInfo!
    }

    type AuctionBidEdge {
      cursor: Cursor
      node: AuctionBid
    }

    type AuctionBidConnection {
      nodes: [AuctionBid]!
      edges: [AuctionBidEdge]!
      pageInfo: PageInfo!
    }

    type Vote implements Node {
      id: ID! @canonical
      subgraphId: Bytes!
    }

    type Question implements Node {
      id: ID! @canonical
      subgraphId: Bytes!
    }

    type Auction implements Node {
      id: ID! @canonical
      subgraphId: Bytes!
    }

    type AuctionBid implements Node {
      id: ID! @canonical
      subgraphId: Bytes!
    }

    type VoteContract implements Node {
      id: ID! @canonical
      address: Bytes!
    }

    type QuestionsContract implements Node {
      id: ID! @canonical
      address: Bytes!
    }

    type AuctionContract implements Node {
      id: ID! @canonical
      address: Bytes!
    }
  `

let resolveArrayToConnection = async (parent, args, context, info, fieldName, delegateFieldName, delegateSchema) => {
  let nodesSelections = info.fieldNodes.find((node) => node.name.value === fieldName)?.selectionSet.selections.find((node) => node.name.value === "nodes")?.selectionSet.selections || []
  let nodeSelections = info.fieldNodes.find((node) => node.name.value === fieldName)?.selectionSet.selections.find((node) => node.name.value === "edges")?.selectionSet.selections.find((node) => node.name.value === "node")?.selectionSet.selections || []
  const array = await delegateToSchema({
    schema: delegateSchema,
    operation: "query",
    fieldName: delegateFieldName,
    args: { ...args, skip: args.offset },
    returnType: delegateSchema.schema.getQueryType().toConfig().fields[delegateFieldName].type,
    selectionSet: {
      "kind": "SelectionSet", args, "selections": [{ "kind": "Field", "name": { "kind": "Name", "value": "id" } },
      ...nodeSelections,
      ...nodesSelections
      ]
    },
    context,
    info,
  })

  return {
    nodes: array, ...connectionFromArray(array, { ...args, first: null })
  }
}

export async function makeGatewaySchema() {
  const answersExec = buildHTTPExecutor({ endpoint: "https://answers.votes.today/graphql" })
  const subgraphExec = buildHTTPExecutor({ endpoint: "https://api.studio.thegraph.com/query/9032/votes-goerli/version/latest" })

  const answersSchema = {
    schema: await schemaFromExecutor(answersExec),
    executor: answersExec,
    batch: true,
  }

  const subgraphSchema = {
    schema: await schemaFromExecutor(subgraphExec),
    executor: subgraphExec,
    batch: true,
    transforms: [new TransformEnumValues((_, externalValue, enumValueConfig) =>
      (externalValue.charAt(0) === "_") ?
        [
          "U" + externalValue, enumValueConfig
        ]
        : enumValueConfig
    )]
  }

  const connectionResolvers = {
    Query: {
      questionConnection: {
        resolve: (parent, args, context, info) => resolveArrayToConnection(parent, args, context, info, "questionConnection", "questions", subgraphSchema)
      },
      voteConnection: {
        resolve: (parent, args, context, info) => resolveArrayToConnection(parent, args, context, info, "voteConnection", "votes", subgraphSchema)
      },
      auctionConnection: {
        resolve: (parent, args, context, info) => resolveArrayToConnection(parent, args, context, info, "auctionConnection", "auctions", subgraphSchema)
      },
      auctionBidConnection: {
        resolve: (parent, args, context, info) => resolveArrayToConnection(parent, args, context, info, "auctionBidConnection", "auctionBids", subgraphSchema)
      }
    },
  }

  const nodeResolvers = {
    Query: {
      node: {
        resolve: (_, args, context, info) => {
          const { type, id } = fromGlobalId(args.id);
          if (subgraphSchema.schema.getTypeMap()[type]) {

            return delegateToSchema({
              schema: subgraphSchema,
              operation: "query",
              fieldName: type[0].toLowerCase() + type.slice(1), // Since single queries in subgraph are camelcase typenames, use type name to make query. Hacky but it works for now.
              args: { id },
              context,
              info,
            })
          } else {
            return delegateToSchema({
              schema: answersSchema,
              operation: "query",
              fieldName: "node",
              args,
              context,
              info,
            })
          }
        },
      },

      vote: {
        resolve: (_, args, context, info) => delegateToSchema({
          schema: subgraphSchema,
          operation: "query",
          fieldName: "vote",
          args: { id: fromGlobalId(args.id).id },
          context,
          info,
        })
      },
      question: {
        resolve: (_, args, context, info) => delegateToSchema({
          schema: subgraphSchema,
          operation: "query",
          fieldName: "question",
          args: { id: fromGlobalId(args.id).id },
          context,
          info,
        })
      },
      auction: {
        resolve: (_, args, context, info) => delegateToSchema({
          schema: subgraphSchema,
          operation: "query",
          fieldName: "auction",
          args: { id: fromGlobalId(args.id).id },
          context,
          info,
        })
      },
      auctionBid: {
        resolve: (_, args, context, info) => delegateToSchema({
          schema: subgraphSchema,
          operation: "query",
          fieldName: "auctionBid",
          args: { id: fromGlobalId(args.id).id },
          context,
          info,
        })
      },
      voteContract: {
        resolve: (_, args, context, info) => delegateToSchema({
          schema: subgraphSchema,
          operation: "query",
          fieldName: "voteContract",
          args: { id: fromGlobalId(args.id).id },
          context,
          info,
        })
      },
      questionsContract: {
        resolve: (_, args, context, info) => delegateToSchema({
          schema: subgraphSchema,
          operation: "query",
          fieldName: "questionsContract",
          args: { id: fromGlobalId(args.id).id },
          context,
          info,
        })
      },
      auctionContract: {
        resolve: (_, args, context, info) => delegateToSchema({
          schema: subgraphSchema,
          operation: "query",
          fieldName: "auctionContract",
          args: { id: fromGlobalId(args.id).id },
          context,
          info,
        })
      },
    },
    Vote: {
      id: {
        resolve: (node) => toGlobalId(node.__typename, node.id)
      },
      subgraphId: {
        resolve: (node) => node.id
      }
    },
    Question: {
      id: {
        resolve: (node) => toGlobalId(node.__typename, node.id)

      },
      subgraphId: {
        resolve: (node,) => node.id
      }
    },
    Auction: {
      id: {
        resolve: (node) => toGlobalId(node.__typename, node.id)
      },
      subgraphId: {
        resolve: (node) => node.id
      }
    },
    AuctionBid: {
      id: {
        resolve: (node) => toGlobalId(node.__typename, node.id)
      },
      subgraphId: {
        resolve: (node) => node.id
      }
    },
    VoteContract: {
      id: {
        resolve: (node) => toGlobalId(node.__typename, node.id)
      },
      address: {
        resolve: (node) => node.id
      }
    },
    QuestionsContract: {
      id: {
        resolve: (node) => toGlobalId(node.__typename, node.id)
      },
      address: {
        resolve: (node) => node.id
      }
    },
    AuctionContract: {
      id: {
        resolve: (node) => toGlobalId(node.__typename, node.id)
      },
      address: {
        resolve: (node) => node.id
      }
    },
  }


  return stitchSchemas({
    subschemas: [answersSchema, subgraphSchema],
    typeDefs: relayCompatibleSchema,
    mergeTypes: true,
    resolvers: [nodeResolvers, connectionResolvers],
    typeMergingOptions: {
      validationSettings: {
        validationLevel: "off", //Todo: fix problems with Node Type
      },
    }
  });

}