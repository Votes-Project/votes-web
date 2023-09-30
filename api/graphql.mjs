// Generated by ReScript, PLEASE EDIT WITH CARE

import * as DataLoaders from "../schema/DataLoaders.mjs";
import * as GraphqlYoga from "graphql-yoga";
import * as ResGraphSchema from "../schema/__generated__/ResGraphSchema.mjs";

var $$default = GraphqlYoga.createYoga({
      schema: ResGraphSchema.schema,
      context: (async function (param) {
          return {
                  dataLoaders: DataLoaders.make(undefined)
                };
        }),
      graphqlEndpoint: "/api/graphql"
    });

export {
  $$default ,
  $$default as default,
}
/* default Not a pure module */