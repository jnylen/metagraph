module.exports = {
  darkMode: "media",
  purge: [
    "../lib/frontend_web/templates/**/*.html.eex",
    "../lib/frontend_web/templates/**/*.html.leex",
    "../lib/frontend_web/live/**/*.html.leex",
  ],
  theme: {
    extend: {
      colors: {
        code: {
          green: "#b5f4a5",
          yellow: "#ffe484",
          purple: "#d9a9ff",
          red: "#ff8383",
          blue: "#93ddfd",
          white: "#ffffff",
        },
      },
    },
  },
  variants: {
    cursor: ["responsive", "hover"],
  },
  plugins: [
    // require("@tailwindcss/ui"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
  ],
};
