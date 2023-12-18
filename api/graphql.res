open GraphQLYoga

@module("../src/schema/gateway.mjs")
external makeGatewaySchema: unit => ResGraph.schema<unit> = "makeGatewaySchema"

let default = createYoga({
  graphqlEndpoint: "/api/graphql",
  schema: makeGatewaySchema(),
  context: async _ => (),
})
