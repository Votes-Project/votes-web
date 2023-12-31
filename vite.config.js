import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react-refresh";
import { rescriptRelayVitePlugin } from "rescript-relay-router/RescriptRelayVitePlugin.mjs";

export default defineConfig(({ command, mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  return {
    server: {
      port: env.PORT || 3000,
    },
    resolve: {
      alias: {
        process: 'process/browser',
        util: 'util',
      },
    },
    plugins: [
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
    optimizeDeps: {
      esbuildOptions: {
        target: "esnext"
      }
    },

    // Prevent ReScript messages from being lost when we run all things at the same time.
    clearScreen: false,
  }
});
