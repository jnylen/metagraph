module.exports = {
  purge: [
    "../lib/frontend_web/templates/**/*.html.eex",
    "../lib/frontend_web/templates/**/*.html.leex",
    "../lib/frontend_web/live/**/*.html.leex",
  ],
  theme: {
    extend: {},
  },
  variants: {
    cursor: ["responsive", "hover"],
  },
  plugins: [require("@tailwindcss/ui"), require("@tailwindcss/custom-forms")],
};
