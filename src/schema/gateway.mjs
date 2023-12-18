import { buildHTTPExecutor } from '@graphql-tools/executor-http';
import { stitchSchemas } from '@graphql-tools/stitch';
import { schemaFromExecutor } from '@graphql-tools/wrap';
import { delegateToSchema } from '@graphql-tools/delegate';
import { connectionFromArray } from 'graphql-relay';

const connectionSchema =
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
    }
  }



  return stitchSchemas({
    subschemas: [answersSchema, subgraphSchema],
    typeDefs: connectionSchema,
    mergeTypes: true,
    resolvers: connectionResolvers
  });

}