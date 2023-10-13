/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{jsx,mjs,res}", "!**/__generated__/**", "!/schema"],
  theme: {
    extend: {
      colors: {
        default: "#e4eaec",
        "default-light": "#ffffff",
        "default-dark": "#a1c7d3",
        "default-darker": "#313753",
        "default-disabled": "#ece6e4",
        primary: "#FFDACC",
        "primary-dark": "#ffae8f",
        secondary: "#fff4f0",
        active: "#FB8A61",
      },
      dropShadow: {
        glow: [
          "0 0px 20px rgba(255,255, 255, 0.35)",
          "0 0px 65px rgba(255, 255,255, 0.2)"
        ]
      },
      flex: {
        '2': '2 2 0%'

      },
      fontFamily: {
        sans: ["Quicksand", 'sans-serif'],
        serif: ['Quicksand', 'sans-serif'],
        mono: ['Quicksand', 'sans-serif'],
        fugaz: ["FugazOne", "sans-serif"],
      },
    },
  },
  plugins: [require("@tailwindcss/forms")],
};
