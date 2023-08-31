/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{jsx,mjs,res}", "!**/__generated__/**", "!/schema"],
  theme: {
    extend: {
      colors: {
        background: "#e4eaec",
        "background-light": "#ffffff",
        "background-dark": "#b6c7cd",
        "default-darker": "#313753",
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
      }
    },
  },
  plugins: [require("@tailwindcss/forms")],
};
