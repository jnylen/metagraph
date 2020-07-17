module.exports = {
  purge: [],
  theme: {
    extend: {},
  },
  variants: {
    cursor: ["responsive", "hover"],
  },
  plugins: [require("@tailwindcss/ui"), require("@tailwindcss/custom-forms")],
};
