module.exports = {
  src: "./src",
  schema: "./schema/__generated__/schema.graphql",
  artifactDirectory: "./src/__generated__",
  exclude: ["**/node_modules/**", "**/graphclient-queries/**", "**/__generated__/**", "**/.graphclient/**"],
  customScalars: {
  },
};
