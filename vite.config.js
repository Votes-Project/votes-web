import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { rescriptRelayVitePlugin } from "rescript-relay-router/RescriptRelayVitePlugin.mjs";
import { virtualIndex } from "rescript-relay-router/VirtualIndex.mjs";

export default defineConfig({
  plugins: [
    virtualIndex({ entryClient: "/src/EntryClient.mjs" }),
    react(),
    rescriptRelayVitePlugin({
      autoScaffoldRenderers: true,
    }),
  ],
  ssr: {
    noExternal: [
      // Work around the fact that rescript-relay is not yet an ESM module
      // which messes up imports on NodeJs.
      "rescript-relay",
    ],
  },
  build: {
    sourcemap: true,
    polyfillDynamicImport: false,
    target: "esnext",
    rollupOptions: {
      output: {
        format: "esm",
        manualChunks: {
          react: ["react", "react-dom"],
          relay: ["react-relay", "relay-runtime"],
        },
      },
    },
  },
  // Prevent ReScript messages from being lost when we run all things at the same time.
  clearScreen: false,
});
