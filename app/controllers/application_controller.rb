class ApplicationController < ActionController::Base
  include Authentication
  before_action :set_paper_trail_whodunnit

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def user_for_paper_trail
    Current.user&.id
  end

  # Override CSRF origin check for dev server
  def valid_request_origin?
    super || (Rails.env.development? && request.origin == ENV.fetch("REACT_DEV_SERVER_ORIGIN"))
  end
end
