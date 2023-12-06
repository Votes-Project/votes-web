type t = Day | HalfCycle | Cycle
let parse = str =>
  switch str {
  | "day" => Some(Day)
  | "halfcycle" => Some(HalfCycle)
  | "cycle" => Some(Cycle)
  | _ => Some(Day)
  }
let serialize = t =>
  switch t {
  | Day => "day"
  | HalfCycle => "halfcycle"
  | Cycle => "cycle"
  }
