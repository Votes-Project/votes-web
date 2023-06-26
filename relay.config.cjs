module.exports = {
  src: "./src",
  schema: "./schemas/schema.graphql",
  artifactDirectory: "./src/__generated__",
  exclude: ["**/node_modules/**", "**/graphclient-queries/**", "**/__generated__/**"],
  customScalars: {
  },
};
