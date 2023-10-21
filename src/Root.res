type history
type vercelEnv =
  | @as("production") Production | @as("development") Development | @as("preview") Preview
@val @scope(("import", "meta", "env"))
external vercelEnv: option<vercelEnv> = "VITE_VERCEL_ENV"

@val
external history: history = "window.history"

@set
external setScrollRestoration: (history, [#manual | #auto]) => unit = "scrollRestoration"

if !RelaySSRUtils.ssr {
  history->setScrollRestoration(#manual)
}

%%raw(`
import './polyfills';
import "./index.css";
import "@rainbow-me/rainbowkit/styles.css";

import { getDefaultWallets } from "@rainbow-me/rainbowkit";
import { configureChains, createConfig } from "wagmi";
import { mainnet, goerli } from "wagmi/chains";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";

// const voteChains = import.meta.env.VITE_VERCEL_ENV === "production" ? [mainnet] : [goerli, mainnet]
const voteChains = [goerli, mainnet];

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
  module Provider = {
    type initialChain<'chain> = 'chain
    @react.component @module("@rainbow-me/rainbowkit")
    external make: (
      ~chains: 'a,
      ~children: React.element,
      ~theme: Theme.t=?,
      ~initialChain: initialChain<'chain>=?,
    ) => React.element = "RainbowKitProvider"
  }
}

module AuctionProvider = {
  open AuctionContext
  @react.component
  let make = (~children) => {
    let (auction, setAuction) = React.useState(_ => None)
    let (isLoading, setIsLoading) = React.useState(_ => true)
    <Provider value={{auction, setAuction, isLoading, setIsLoading}}> {children} </Provider>
  }
}
module VoteProvider = {
  open VoteContext
  @react.component
  let make = (~children) => {
    let (vote, setVote) = React.useState(_ => None)

    <Provider value={{vote, setVote}}> {children} </Provider>
  }
}

module RequireVerificationProvider = {
  open VerificationContext
  @react.component
  let make = (~children) => {
    let (verification, setVerification) = React.useState(_ => None)
    <Provider value={{verification, setVerification}}> {children} </Provider>
  }
}

module HeroComponentProvider = {
  open HeroComponentContext
  @react.component
  let make = (~children) => {
    let (heroComponent, setHeroComponent) = React.useState(_ => React.null)
    <Provider value={{heroComponent, setHeroComponent}}> {children} </Provider>
  }
}

ReactDOMExperimental.renderConcurrentRootAtElementWithId(
  <RescriptRelay.Context.Provider environment={RelayEnv.environment}>
    <RelayRouter.Provider value={Router.routerContext}>
      <React.Suspense
        fallback={
          open FramerMotion
          <>
            <div className="text-center w-screen h-screen flex items-center justify-center">
              <QuestionPreview.QuestionTitle />
            </div>
            <Motion.Div
              layoutId="background-noise"
              layout=String("opacity")
              initial={Initial({opacity: 0.})}
              animate={Animate({opacity: 1.})}
              className="bg-primary noise fixed animate-[grain_12s_steps(10)_infinite] w-[300%] h-[300%] left-[-50%] top-[-100%] -z-10"
            />
          </>
        }>
        <ErrorBoundary
          fallback={({error}) => <>
            {`Error! \n ${error->Exn.name->Option.getWithDefault("")}: ${error
              ->Exn.message
              ->Option.getWithDefault(
                "Something went wrong connecting to the votes API",
              )}`->React.string}
          </>}>
          <Wagmi.WagmiConfig config={%raw("wagmiConfig")}>
            <RainbowKit.Provider chains={%raw("chains")} initialChain={%raw("goerli")}>
              <VoteProvider>
                <AuctionProvider>
                  <HeroComponentProvider>
                    <RelayRouter.RouteRenderer
                      // This renders all the time, and when there"s a pending navigation (pending via React concurrent mode), pending will be `true`
                      renderPending={pending => <PendingIndicatorBar pending />}
                    />
                  </HeroComponentProvider>
                </AuctionProvider>
              </VoteProvider>
            </RainbowKit.Provider>
          </Wagmi.WagmiConfig>
        </ErrorBoundary>
      </React.Suspense>
    </RelayRouter.Provider>
  </RescriptRelay.Context.Provider>,
  "root",
)
