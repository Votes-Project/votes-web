type t = {
  byId: DataLoader.t<string, option<Question.question>>,
  random: DataLoader.t<string, array<Question.question>>,
}

let triviaApi = "https://the-trivia-api.com/v2"
let singleQuestion = id => triviaApi ++ `/question/${id}`
let randomQuestions = limit => triviaApi ++ `/questions?limit=${limit}`

open Fetch
let make = () => {
  byId: DataLoader.makeSingle(async id => {
    switch await id->singleQuestion->fetch({method: #GET}) {
    | exception _ => None
    | res =>
      switch (res->Response.status, await res->Response.json) {
      | (200, json) =>
        json->S.parseWith(Question.questionStruct)->Result.mapWithDefault(None, q => Some(q))
      | (_, _) => None
      | exception _ => None
      }
    }
  }),
  random: DataLoader.makeSingle(async limit => {
    switch await limit->randomQuestions->fetch({method: #GET}) {
    | exception _ => []
    | res =>
      switch (res->Response.status, await res->Response.json) {
      | (200, json) =>
        json
        ->S.parseAnyWith(S.array(Question.questionStruct)->S.Object.strip)
        ->Result.getWithDefault([])

      | (_, _) => []
      | exception _ => []
      }
    }
  }),
}
