%%raw(`import {
  Chart as ChartJS,
  RadialLinearScale,
  PointElement,
  LineElement,
  Filler,
} from 'chart.js'`)

%%raw(`ChartJS.register(
  RadialLinearScale,
  PointElement,
  LineElement,
  Filler,
)`)

open ChartJS

let options: RadarChart.options = {
  animations: {
    tension: {
      duration: 2000,
      easing: "linear",
      from: 0.6,
      to_: 0.3,
      loop: true,
    },
  },
  scales: {
    r: {ticks: {display: false}},
  },
}

@react.component
let make = (~className) => {
  let rndInt = (Math.floor(Math.random() *. 6.) +. 3.)->Float.toInt
  let labels = Array.make(~length=rndInt, "")
  let data = {
    labels,
    datasets: [
      {
        data: Array.make(~length=rndInt, 0.)->Array.map(_ => Math.random() *. 100.),
        backgroundColor: "rgba(1, 1, 1, 0.2)",
        borderWidth: 0,
      },
    ],
  }
  <ChartJS.RadarChart data options className />
}
