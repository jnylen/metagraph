const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  darkMode: "media",
  purge: [
    "../lib/frontend_web/templates/**/*.html.eex",
    "../lib/frontend_web/templates/**/*.html.leex",
    "../lib/frontend_web/live/**/*.html.leex",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
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
    extend: {
      cursor: ["responsive", "hover"],
      mixBlendMode: ["responsive"],
    },
  },
  plugins: [
    // require("@tailwindcss/ui"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
  ],
};
