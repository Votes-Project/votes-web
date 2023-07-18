open GraphQLYoga

let default = createYoga({
  graphqlEndpoint: "/api/graphql",
  schema: ResGraphSchema.schema,
  context: async _ => {
    {
      ResGraphContext.dataLoaders: DataLoaders.make(),
    }
  },
})
