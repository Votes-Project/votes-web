exception NoVoterCount
module Fragment = %relay(`
 fragment VoterCount_users on UserConnection {
   totalCount
 }`)

@react.component
let make = (~users) => {
  let {totalCount} = Fragment.use(users->Option.getExn)

  <p className="text-lg ml-1 mr-2"> {totalCount->Int.toLocaleString->React.string} </p>
}
