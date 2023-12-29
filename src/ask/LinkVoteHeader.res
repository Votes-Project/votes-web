module Query = %relay(`
  query LinkVoteHeaderQuery(
    $voteConnectionWhere: Vote_filter!
    $questionConnectionWhere: Question_filter!
    $skipVoteConnection: Boolean!
  ) {
    voteConnection(
      where: $voteConnectionWhere
      orderBy: tokenId
      orderDirection: asc
    ) @skip(if: $skipVoteConnection) {
      nodes {
        id
        tokenId
      }
    }
    questionConnection(where: $questionConnectionWhere) {
      nodes {
        id
        vote {
          tokenId
        }
        state
      }
    }
  }
`)

// <div className="flex flex-row justify-center items-center">
//   {switch selectedVote {
//   | Some(vote) =>
//     <p className="text-4xl font-bold"> {vote.tokenId->BigInt.toString->React.string} </p>
//   | None =>
//     <div
//       className="py-2 px-3 bg-indigo-500/50 text-white text-xs font-bold rounded-2xl flex justify-center items-center">
//       {"Seed"->React.string}
//     </div>
//   }}
//   <p> {"# X in queue"->React.string} </p>
// </div>
