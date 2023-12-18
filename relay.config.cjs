module.exports = {
  src: "./src",
  schema: "./src/schema/schema.graphql",
  artifactDirectory: "./src/__generated__",
  exclude: ["**/node_modules/**"],
  language: "rescript",
  featureFlags: {
    enable_relay_resolver_transform: true,
  },
  customScalars: {
    Timestamp: "Scalars.Timestamp",
    BigInt: "Scalars.BigInt",
  },
};
