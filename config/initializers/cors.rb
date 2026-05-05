# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

if Rails.env.development?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins "http://localhost:5173"

      resource "*",
        headers: :any,
        methods: %i[get post put patch delete options head],
        credentials: true,         # required for cookie-based sessions
        expose: [ "X-CSRF-Token" ]   # let the browser read the token header
    end
  end
end
