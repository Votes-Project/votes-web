type t

type chartType = | @as("line") Line | @as("bar") Bar | @as("radar") Radar
type dataset<'data> = {
  label?: string,
  data: 'data,
  backgroundColor?: string,
  borderWidth?: int,
  borderColor?: string,
  pointBackgroundColor?: string,
  pointBorderColor?: string,
  pointHoverBackgroundColor?: string,
  pointHoverBorderColor?: string,
}
type data<'data> = {datasets: array<dataset<'data>>, labels: array<string>}

type tension = {
  duration: int,
  easing: string,
  from: float,
  @as("to") to_: float,
  loop: bool,
}

module RadarChart = {
  type animation = {tension?: tension}
  type ticks = {display: bool}
  type scale = {ticks: ticks}
  type scales = {r?: scale}
  type options = {animations?: animation, scales?: scales}
  type plugin = {}
  type config<'data> = {
    @as("type") type_: chartType,
    data: data<'data>,
    options?: options,
    plugins?: array<plugin>,
  }
  @react.component @module("react-chartjs-2")
  external make: (~data: data<'data>, ~options: options=?, ~className: string=?) => React.element =
    "Radar"
}
