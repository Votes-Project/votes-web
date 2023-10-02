let nodeUrl = "https://app.brightid.org/node/v5/"
let verificationsUrl = nodeUrl ++ "verifications/"

/** BrightID Error object */
@gql.type
type error = {
  /** Returns true if response is an error */
  @gql.field
  error: bool,
  /** The error number */
  @gql.field
  errorNum: int,
  /** The error message */
  @gql.field
  errorMessage: string,
  /** The error code */
  @gql.field
  code: int,
}

let errorStruct = {
  open S
  object(({field}) => {
    error: "error"->field(bool),
    errorNum: "errorNum"->field(int),
    errorMessage: "errorMessage"->field(string),
    code: "code"->field(int),
  })
}

type data<'data> = {data: 'data}

let dataStruct = struct => {
  open S
  object(({field}) => {
    data: "data"->field(struct),
  })
}
