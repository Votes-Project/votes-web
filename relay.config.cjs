module.exports = {
  src: "./src",
  schema: "./schema/__generated__/schema.graphql",
  artifactDirectory: "./src/__generated__",
  exclude: ["**/node_modules/**", "./schema/graphclient-queries/**", "./.graphclient/**"],
  language: "rescript",
  featureFlags: {
    enable_relay_resolver_transform: true,
  },
  customScalars: {
    Timestamp: "Scalars.Timestamp",
    BigInt: "Scalars.BigInt",
  },
};
