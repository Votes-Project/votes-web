module String = {
  include String
  @send external replaceAll: (string, string, string) => string = "replaceAll"
}

type t = Date.t
let parse = str => str->String.replaceAll("-", "/")->Date.fromString->Some

let serialize = t =>
  switch t->Date.toLocaleDateStringWithLocaleAndOptions("en-US", {dateStyle: #short}) {
  | "Invalid Date" => ""
  | date => date->String.replaceAll("/", "-")
  }
