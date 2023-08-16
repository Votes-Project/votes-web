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

const voteChains = import.meta.env.NODE_ENV === "production" ? [optimism] : [goerli, optimism];

const { chains, publicClient, webSocketPublicClient } = configureChains(
  voteChains,
  [
    alchemyProvider({ apiKey: import.meta.env.VITE_PRIVATE_ALCHEMY_ID }),
    publicProvider(),
  ]
);



const { connectors } = getDefaultWallets({
  appName: "Votes",
  projectId: import.meta.env.VITE_WALLETCONNECT_PROJECT_ID,
  chains,
});

const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
  webSocketPublicClient
});

`)

module RainbowKit = {
  module Theme = {
    type t
    type themeInput = {
      accentColor?: string,
      accentColorForeground?: string,
      borderRadius?: string,
      fontStack?: string,
      overlayBlur?: string,
    }
    @module("@rainbow-me/rainbowkit") external darkTheme: themeInput => t = "darkTheme"
  }
  module RainbowKitProvider = {
    @react.component @module("@rainbow-me/rainbowkit")
    external make: (~chains: 'a, ~children: React.element, ~theme: Theme.t=?) => React.element =
      "RainbowKitProvider"
  }
}

module TodaysAuctionProvider = {
  open TodaysAuctionContext
  @react.component
  let make = (~children) => {
    let (todaysAuction, setTodaysAuction) = React.useState(_ => None)
    <TodaysAuctionContext.Provider value={{todaysAuction, setTodaysAuction}}>
      {children}
    </TodaysAuctionContext.Provider>
  }
}

module RequireVerificationProvider = {
  open RequireVerificationContext
  @react.component
  let make = (~children) => {
    let (verification, setVerification) = React.useState(_ => None)
    <RequireVerificationContext.Provider value={{verification, setVerification}}>
      {children}
    </RequireVerificationContext.Provider>
  }
}

ReactDOMExperimental.renderConcurrentRootAtElementWithId(
  <RescriptRelay.Context.Provider environment={RelayEnv.environment}>
    <RelayRouter.Provider value={Router.routerContext}>
      <React.Suspense fallback={React.string("Loading...")}>
        // <RescriptReactErrorBoundary fallback={_ => {<div> {React.string("Error!")} </div>}}>
        <Wagmi.WagmiConfig config={%raw("wagmiConfig")}>
          <RainbowKit.RainbowKitProvider chains={%raw("chains")}>
            <TodaysAuctionProvider>
              <RelayRouter.RouteRenderer
                // This renders all the time, and when there's a pending navigation (pending via React concurrent mode), pending will be `true`
                renderPending={pending => <PendingIndicatorBar pending />}
              />
            </TodaysAuctionProvider>
          </RainbowKit.RainbowKitProvider>
        </Wagmi.WagmiConfig>
        // </RescriptReactErrorBoundary>
      </React.Suspense>
    </RelayRouter.Provider>
  </RescriptRelay.Context.Provider>,
  "root",
)
