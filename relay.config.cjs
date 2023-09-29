module.exports = {
  src: "./src",
  schema: "./schema/__generated__/schema.graphql",
  artifactDirectory: "./src/__generated__",
  exclude: ["**/node_modules/**", "./schema/graphclient-queries/**", "./.graphclient/**"],
  language: "rescript",
};
