open GraphQLYoga

module Plugins = {
  module Cookies = {
    @module("@whatwg-node/server-plugin-cookies")
    external use: unit => GraphQLYoga.Envelope.plugin = "useCookies"
  }
}

let default = createYoga({
  graphqlEndpoint: "/api/graphql",
  schema: ResGraphSchema.schema,
  plugins: [Plugins.Cookies.use()],
  context: async ({request}) => {
    {
      ResGraphContext.dataLoaders: DataLoaders.make(),
      ResGraphContext.mutations: Mutations.make(),
      request,
    }
  },
})
