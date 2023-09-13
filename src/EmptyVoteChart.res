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

let labels = ["", "", "", "", ""]

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
  let data = {
    labels,
    datasets: [
      {
        data: [
          Math.random() *. 100.,
          Math.random() *. 100.,
          Math.random() *. 100.,
          Math.random() *. 100.,
          Math.random() *. 100.,
        ],
        backgroundColor: "rgba(1, 1, 1, 0.2)",
        borderWidth: 0,
      },
    ],
  }
  <ChartJS.RadarChart data options className />
}
