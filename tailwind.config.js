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
        sans: ["Inter", 'sans'],
        serif: ['Inter', 'sans-serif'],
        mono: ['Inter', 'mono'],
        fugaz: ["FugazOne", "sans-serif"],
      },
      animation: {
        typewriter: "typewriter 1s steps(11) forwards"
      },
      keyframes: {
        typewriter: {
          to: {
            left: "100%"
          }
        }
      }
    },
  },
  plugins: [],
};
