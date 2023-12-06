@react.component
let make = () => {
  let calendarOptions = [("day", "Day"), ("halfcycle", "Half Cycle"), ("cycle", "Cycle")]

  calendarOptions
  ->Array.map(((value, text)) => {
    <option key=value value> {text->React.string} </option>
  })
  ->React.array
}
