exception NoVoterCount
module Fragment = %relay(`
 fragment VoterCount_verifications on Verifications {
   ... on VerificationsData {
     count
   }
   ... on Error {
     errorMessage
   }
 }`)

@react.component
let make = (~verifications) => {
  let verifications = Fragment.use(verifications)

  {
    switch verifications {
    | VerificationsData({count}) =>
      <p className="text-lg ml-1 mr-2"> {count->Int.toLocaleString->React.string} </p>
    | _ => raise(NoVoterCount)
    }
  }
}
