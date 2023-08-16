/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{jsx,mjs,res}", "!**/__generated__/**", "!/schema"],
  theme: {
    extend: {
      colors: {
        background: "#D6D8E6",
        "background-light": "#E9EAF2",
        "background-dark": "#828AB5",
        "default-darker": "#313753",
        primary: "#FFDACC",
        secondary: "#FFF0EB",
        active: "#FB8A61",
      },
    },
  },
  plugins: [require("@tailwindcss/forms")],
};
