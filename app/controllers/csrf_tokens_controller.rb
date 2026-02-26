class CsrfTokensController < ApplicationController
  allow_unauthenticated_access

  # GET /csrf_token
  # Returns a fresh CSRF token for the caller's session.
  def show
    render json: { csrf_token: form_authenticity_token }
  end
end
