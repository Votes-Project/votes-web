type questionOption = {
  option?: string,
  details?: string,
}
type question = {title: option<string>, options: array<questionOption>}

let emptyQuestion = {
  title: None,
  options: [{}, {}],
}

let decodeQuestionOption = json =>
  switch json->JSON.Decode.object {
  | Some(questionOptionDict) =>
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
  switch json->JSON.Decode.object {
  | Some(questionDict) =>
    switch questionDict->Dict.get("options") {
    | Some(Array(options)) => options->Array.map(decodeQuestionOption)
    | _ => []
    }
  | _ => []
  }

let decodeTitle = json =>
  switch json->JSON.Decode.object {
  | Some(questionDict) =>
    switch questionDict->Dict.get("title") {
    | Some(String(title)) => Some(title)
    | _ => None
    }
  | _ => None
  }

let decodeQuestion = json => {
  title: json->decodeTitle,
  options: json->decodeOptions,
}

let parseHexTitle = hex => {
  try {
    switch hex->Viem.hexToString->JSON.parseExn->decodeTitle {
    | Some(title) => Some(title)
    | None => None
    }
  } catch {
  | _ => None
  }
}

let parseHexOptions = hex => {
  try {
    hex->Viem.hexToString->JSON.parseExn->decodeOptions
  } catch {
  | _ => []
  }
}

let parseHexQuestion = hex => {
  hex->Option.flatMap(hex => {
    try {
      hex->Viem.hexToString->JSON.parseExn->decodeQuestion->Some
    } catch {
    | _ => None
    }
  })
}
