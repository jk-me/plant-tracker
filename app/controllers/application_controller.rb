class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  # Override CSRF origin check for dev server
  def valid_request_origin?
    super || (Rails.env.development? && request.origin == ENV.fetch("REACT_DEV_SERVER_ORIGIN"))
  end
end
