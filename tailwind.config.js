const plugin = require('tailwindcss/plugin');

module.exports = {
    daisyui: {
          themes: [
            {
              mytheme: {              
                 "primary": "#3730a3",
                 "secondary": "#4338ca",
                 "accent": "#fef08a",
                 "neutral": "#3730a3",
                 "base-100": "#f8f8ff",
                 "info": "#06b6d4",
                 "success": "#16a34a",
                 "warning": "#fcd34d",
                 "error": "#e880b4",
              },
            },
          ],
    },
    plugins: [require("daisyui")],
    content: [
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ]
}
