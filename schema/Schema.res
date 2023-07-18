@gql.type
type query

/** The current time on the server, as a timestamp. */
@gql.field
let currentTime = (_: query) => {
  Some(Date.now())
}
