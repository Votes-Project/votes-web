let triviaApi = "https://the-trivia-api.com/v2"
let singleQuestion = id => triviaApi ++ `/question/${id}`
let randomQuestions = limit => triviaApi ++ `/questions?limit=${limit}`

open GraphClient

type questionsArgs<'orderBy, 'where> = {
  first: option<int>,
  orderBy: 'orderBy,
  orderDirection: option<orderDirection>,
  where: 'where,
}

@gql.enum
type orderBy_Questions =
  | @as("id") ID
  | @as("tokenId") TokenId

@gql.inputObject
type where_Questions = {
  id?: string,
  tokenId?: string,
}

type t = {
  byId: DataLoader.t<string, option<Question.question>>,
  list: DataLoader.t<
    questionsArgs<option<orderBy_Questions>, option<where_Questions>>,
    array<Question.question>,
  >,
  triviaById: DataLoader.t<string, option<Question.triviaQuestion>>,
  random: DataLoader.t<string, array<Question.triviaQuestion>>,
}

type questionFromContract = {
  id: string,
  question: string,
  tokenId: string,
  isLocked: bool,
  contract: GraphClient.linkById,
}
module ById = {
  type data = {question: Nullable.t<questionFromContract>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetQuestionDocument"
  let make = DataLoader.makeSingle(async id =>
    switch await GraphClient.executeWithId(document, {id: id}) {
    | exception _ => None
    | res =>
      res.data->Option.flatMap(({question}) =>
        switch question->Nullable.toOption {
        | Some(question) =>
          switch question.question->Some->QuestionUtils.parseHexQuestion {
          | None => None
          | Some({title: None, options}) =>
            Some(
              (
                {
                  id: question.id,
                  question: "",
                  tokenId: question.tokenId,
                  options,
                  isLocked: question.isLocked,
                  contract: {id: question.contract.id},
                }: Question.question
              ),
            )
          | Some({title: Some(title), options}) =>
            Some(
              (
                {
                  id: question.id,
                  question: title,
                  tokenId: question.tokenId,
                  options,
                  isLocked: question.isLocked,
                  contract: {id: question.contract.id},
                }: Question.question
              ),
            )
          }
        | None => None
        }
      )
    }
  )
}

module List = {
  type data = {questions: array<questionFromContract>}
  @module("../.graphclient/index.js") @val
  external document: GraphClient.document<GraphClient.result<data>> = "GetQuestionsDocument"
  let make = DataLoader.makeSingle(async args => {
    switch await GraphClient.executeWithList(
      document,
      {
        first: args.first->Option.getWithDefault(1000),
        orderBy: args.orderBy->Option.getWithDefault(ID),
        orderDirection: args.orderDirection->Option.getWithDefault(Asc),
        where: args.where->Option.getWithDefault(({}: where_Questions)),
      },
    ) {
    | exception _ => []
    | res =>
      res.data->Option.mapWithDefault([], ({questions}) =>
        questions->Array.map(
          question =>
            switch question.question->Some->QuestionUtils.parseHexQuestion {
            | None =>
              (
                {
                  id: question.id,
                  question: "",
                  tokenId: question.tokenId,
                  options: [],
                  isLocked: question.isLocked,
                  contract: {id: question.contract.id},
                }: Question.question
              )

            | Some({title: None, options}) =>
              (
                {
                  id: question.id,
                  question: "",
                  tokenId: question.tokenId,
                  options,
                  isLocked: question.isLocked,
                  contract: {id: question.contract.id},
                }: Question.question
              )

            | Some({title: Some(title), options}) =>
              (
                {
                  id: question.id,
                  question: title,
                  tokenId: question.tokenId,
                  options,
                  isLocked: question.isLocked,
                  contract: {id: question.contract.id},
                }: Question.question
              )
            },
        )
      )
    }
  })
}

open Fetch
let make = () => {
  byId: ById.make,
  list: List.make,
  triviaById: DataLoader.makeSingle(async id => {
    switch await id->singleQuestion->fetch({method: #GET}) {
    | exception _ => None
    | res =>
      switch (res->Response.status, await res->Response.json) {
      | (200, json) =>
        json->S.parseWith(Question.triviaQuestionStruct)->Result.mapWithDefault(None, q => Some(q))
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
        ->S.parseAnyWith(S.array(Question.triviaQuestionStruct)->S.Object.strip)
        ->Result.getWithDefault([])

      | (_, _) => []
      | exception _ => []
      }
    }
  }),
}
