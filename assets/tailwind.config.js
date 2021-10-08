module.exports = {
  purge: {
    layers: ['components', 'utilities'],
    enabled: process.env.NODE_ENV === "production",
    content: [
      "../lib/**/*.ex",
      "../lib/**/*.eex",
      "../lib/**/*.leex",
      "../lib/**/*.heex",
      "../lib/**/*_view.ex"
    ],
    options: {
      whitelist: [/phx/, /nprogress/]
    }
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms')
  ],
}

