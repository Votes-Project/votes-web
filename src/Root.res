type history

@val
external history: history = "window.history"

@set
external setScrollRestoration: (history, [#manual | #auto]) => unit = "scrollRestoration"

if !RelaySSRUtils.ssr {
  history->setScrollRestoration(#manual)
}

let _ = Environment.env

%%raw(`
import './polyfills';
import "./index.css";
import "@rainbow-me/rainbowkit/styles.css";

import { getDefaultWallets } from "@rainbow-me/rainbowkit";
import { configureChains, createConfig } from "wagmi";
import { mainnet, goerli } from "wagmi/chains";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";


const voteChains = Environment.env === "production" ?
  [mainnet] :  Environment.env === "preview"? [mainnet, goerli] : [goerli];


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

module VerificationProvider = {
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

module VotesySpeakProvider = {
  open VotesySpeakContext
  @react.component
  let make = (~children) => {
    let (content, setContent) = React.useState(_ => None)
    let (position, setPosition) = React.useState(_ => Fixed)
    let (show, setShow) = React.useState(_ => false)

    React.useEffect1(() => {
      switch content {
      | None => ()
      | Some(_) => setShow(_ => true)
      }
      None
    }, [content])

    <Provider value={{content, setContent, show, setShow, position, setPosition}}>
      {children}
    </Provider>
  }
}

module QuestionProvider = {
  open QuestionContext
  @react.component
  let make = (~children) => {
    let (question, setQuestion) = React.useState(_ => None)

    <Provider value={{question, setQuestion}}> {children} </Provider>
  }
}
module StatsAlertProvider = {
  open StatsAlertContext
  @react.component
  let make = (~children) => {
    let (alerts, setAlerts) = React.useState(() => [])

    <StatsAlertContext.Provider value={{alerts, setAlerts}}>
      {children}
    </StatsAlertContext.Provider>
  }
}

let localPrivateKey = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_privateKey")
let localPublicKey = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_publicKey")
let localContextId = Dom.Storage2.localStorage->Dom.Storage2.getItem("votes_contextId")

let initializeKeyPair = async () => {
  switch await Jose.generateKeyPair(
    ES256,
    ~options={
      extractable: true,
    },
  ) {
  | {publicKey, privateKey} =>
    switch (
      await Jose.exportSPKI(publicKey),
      await Jose.exportPKCS8(privateKey),
      await {Jose.exportJWK(publicKey)}->Promise.then(Jose.calculateJwkThumbprint),
    ) {
    | (publicKey, privateKey, contextId) =>
      if localPrivateKey->Option.isNone {
        Dom.Storage2.localStorage->Dom.Storage2.setItem("votes_privateKey", privateKey)
      }
      if localPublicKey->Option.isNone {
        Dom.Storage2.localStorage->Dom.Storage2.setItem("votes_publicKey", publicKey)
      }
      if localContextId->Option.isNone {
        Dom.Storage2.localStorage->Dom.Storage2.setItem("votes_contextId", contextId)
      }
    }

  | exception e => raise(e)
  }
}

initializeKeyPair()->ignore

ReactDOMExperimental.renderConcurrentRootAtElementWithId(
  <RescriptRelay.Context.Provider environment={RelayEnv.environment}>
    <RelayRouter.Provider value={Router.routerContext}>
      <Wagmi.WagmiConfig config={%raw("wagmiConfig")}>
        <RainbowKit.Provider chains={%raw("chains")} initialChain={%raw("goerli")}>
          <VerificationProvider>
            <VoteProvider>
              <AuctionProvider>
                <QuestionProvider>
                  <HeroComponentProvider>
                    <VotesySpeakProvider>
                      <StatsAlertProvider>
                        <React.Suspense
                          fallback={
                            open FramerMotion

                            let title = "This is a placeholder for the daily question which will be rendered server side"
                            <>
                              <div
                                className="text-center w-screen h-screen flex items-center justify-center">
                                <div className="">
                                  <FramerMotion.Div
                                    layout=Position
                                    layoutId="daily-question-title"
                                    className={`font-bold [text-wrap:balance] text-center text-default-darker px-4 text-2xl`}>
                                    {("\"" ++ title ++ "\"")->React.string}
                                  </FramerMotion.Div>
                                </div>
                              </div>
                              <FramerMotion.Div
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
                            <RelayRouter.RouteRenderer
                              // This renders all the time, and when there"s a pending navigation (pending via React concurrent mode), pending will be `true`
                              renderPending={pending => <PendingIndicatorBar pending />}
                            />
                          </ErrorBoundary>
                        </React.Suspense>
                      </StatsAlertProvider>
                    </VotesySpeakProvider>
                  </HeroComponentProvider>
                </QuestionProvider>
              </AuctionProvider>
            </VoteProvider>
          </VerificationProvider>
        </RainbowKit.Provider>
      </Wagmi.WagmiConfig>
    </RelayRouter.Provider>
  </RescriptRelay.Context.Provider>,
  "root",
)
