type question = {title: option<string>, options: array<Question.questionOption>}

let emptyQuestion = {
  title: None,
  options: [{}, {}],
}

let decodeQuestionOption = json =>
  switch json->JSON.Decode.object {
  | Some(questionOptionDict) =>
    open Question
    switch (questionOptionDict->Dict.get("option"), questionOptionDict->Dict.get("details")) {
    | (Some(option), Some(details)) => {
        option: ?option->JSON.Decode.string,
        details: ?details->JSON.Decode.string,
      }
    | (Some(option), None) => {
        option: ?option->JSON.Decode.string,
        details: ?None,
      }
    | _ => {}
    }
  | _ => {}
  }

let decodeOptions = json =>
  switch json->JSON.Decode.array {
  | Some(options) => options->Array.map(decodeQuestionOption)
  | _ => []
  }

let decodeQuestion = json =>
  switch json->JSON.Decode.object {
  | Some(questionDict) =>
    switch (questionDict->Dict.get("title"), questionDict->Dict.get("options")) {
    | (Some(String(title)), Some(options)) =>
      Some({
        title: Some(title),
        options: options->decodeOptions,
      })
    | (Some(String(title)), None) =>
      Some({
        title: Some(title),
        options: [],
      })
    | _ => None
    }
  | _ => None
  }

let parseHexQuestion = hex => {
  hex->Option.flatMap(hex => {
    try {
      switch hex->Viem.hexToString->JSON.parseExn->decodeQuestion {
      | Some(question) => Some(question)
      | None => None
      }
    } catch {
    | _ => None
    }
  })
}
