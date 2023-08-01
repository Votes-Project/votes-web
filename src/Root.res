type history

@val
external history: history = "window.history"

@set
external setScrollRestoration: (history, [#manual | #auto]) => unit = "scrollRestoration"

if !RelaySSRUtils.ssr {
  history->setScrollRestoration(#manual)
}

%%raw(`
import "./index.css";
import "@rainbow-me/rainbowkit/styles.css";

import { getDefaultWallets } from "@rainbow-me/rainbowkit";
import { configureChains, createConfig } from "wagmi";
import { optimism, goerli } from "wagmi/chains";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";

const { chains, publicClient } = configureChains(
  [import.meta.env.NODE_ENV === "production" ? optimism : goerli],
  [
    alchemyProvider({ apiKey: import.meta.env.VITE_PRIVATE_ALCHEMY_ID }),

    publicProvider(),
  ]
);



const { connectors } = getDefaultWallets({
  appName: "My RainbowKit App",
  projectId: import.meta.env.VITE_WALLETCONNECT_PROJECT_ID,
  chains,
});

const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
});

`)

module WagmiConfig = {
  @react.component @module("wagmi")
  external make: (~config: 'a, ~children: React.element) => React.element = "WagmiConfig"
}
module RainbowKitProvider = {
  @react.component @module("@rainbow-me/rainbowkit")
  external make: (~chains: 'a, ~children: React.element) => React.element = "RainbowKitProvider"
}

ReactDOMExperimental.renderConcurrentRootAtElementWithId(
  <RescriptRelay.Context.Provider environment={RelayEnv.environment}>
    <RelayRouter.Provider value={Router.routerContext}>
      <React.Suspense fallback={React.string("Loading...")}>
        // <RescriptReactErrorBoundary fallback={_ => {<div> {React.string("Error!")} </div>}}>
        <WagmiConfig config={%raw("wagmiConfig")}>
          <RainbowKitProvider chains={%raw("chains")}>
            <RelayRouter.RouteRenderer
              // This renders all the time, and when there's a pending navigation (pending via React concurrent mode), pending will be `true`
              renderPending={pending => <PendingIndicatorBar pending />}
            />
          </RainbowKitProvider>
        </WagmiConfig>
        // </RescriptReactErrorBoundary>
      </React.Suspense>
    </RelayRouter.Provider>
  </RescriptRelay.Context.Provider>,
  "root",
)
