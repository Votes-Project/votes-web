@react.component
let make = () => {
  let {queryParams} = Routes.Main.Question.Route.useQueryParams()

  switch queryParams.answer {
  | Some(_) =>
    <h1 className="text-2xl px-4 pt-2 text-default-darker lg:text-active text-center animate-pulse">
      {"Hold to Confirm"->React.string}
    </h1>
  | None =>
    <h1 className="text-2xl px-4 pt-2 text-default-dark lg:text-primary-dark text-center ">
      {"Pick an answer"->React.string}
    </h1>
  }
}
