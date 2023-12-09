type vercelEnv =
  | @as("production") Production | @as("development") Development | @as("preview") Preview

@val @scope(("import", "meta", "env"))
external vercelEnv: option<vercelEnv> = "VITE_VERCEL_ENV"
@val @scope(("import", "meta", "env"))
external vercelUrl: option<string> = "VITE_VERCEL_URL"
@val @scope(("import", "meta", "env"))
external port: option<string> = "PORT"

@val @scope(("import", "meta", "env"))
external auctionContractAddress: option<string> = "VITE_AUCTION_CONTRACT_ADDRESS"
@val @scope(("import", "meta", "env"))
external votesContractAddress: option<string> = "VITE_VOTES_CONTRACT_ADDRESS"
@val @scope(("import", "meta", "env"))
external questionsContractAddress: option<string> = "VITE_QUESTIONS_CONTRACT_ADDRESS"

exception MissingEnvVariable({name: string})

let env = switch vercelEnv {
| Some(env) => env
| None => raise(MissingEnvVariable({name: "VITE_VERCEL_ENV"}))
}

let vercelUrl = switch (env, vercelUrl) {
| (Production, Some(url)) => url
| (Preview, Some(url)) => url
| (Development, _) => "localhost"
| _ => raise(MissingEnvVariable({name: "VITE_VERCEL_URL"}))
}

let port = switch (env, port) {
| (Development, Some(port)) => port
| (Development, None) => "3000"
| _ => ""
}

let publicUrl = switch (env, vercelUrl, port) {
| (Production, url, _) => "https://" ++ url
| (Preview, url, _) => "https://" ++ url
| (Development, url, port) => "http://" ++ url ++ ":" ++ port
}

let auctionContractAddress = switch (env, auctionContractAddress) {
| (_, Some(address)) => address->String.toLowerCase
| (Development | Preview, None) => "0x27C4ae0477011F993a411032ae3bE38A64ebb113"->String.toLowerCase
| (Production, None) => ""
}
let votesContractAddress = switch (env, votesContractAddress) {
| (_, Some(address)) => address->String.toLowerCase
| (Development | Preview, None) => "0xA237b3cC022F70B45AFdbe62EdF9C12ac36932F8"->String.toLowerCase
| (Production, None) => ""
}

let questionsContractAddress = switch (env, questionsContractAddress) {
| (_, Some(address)) => address->String.toLowerCase
| (Development | Preview, None) => "0x7fBd86f05A3E505659E132dCa2Af85f9380dd16D"->String.toLowerCase
| (Production, None) => ""
}

module FeatureFlags = {
  @val @scope(("import", "meta", "env"))
  external enableCharts: option<string> = "VITE_ENABLE_CHARTS"
  type t = {mutable enableCharts: bool}
  let t = {
    enableCharts: switch enableCharts {
    | Some("true") => true
    | _ => false
    },
  }
}

let featureFlags = FeatureFlags.t
