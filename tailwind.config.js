/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{jsx,mjs,res}", "!**/__generated__/**", "!/schema"],
  theme: {
    extend: {
      colors: {
        background: "#D6D8E6",
        primary: "#FFDACC",
      },
    },
  },
  plugins: [],
};
