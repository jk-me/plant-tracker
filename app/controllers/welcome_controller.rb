class WelcomeController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]

  def index
    if authenticated?
      redirect_to plants_path
    end
  end

  def signup
    # This action renders the signup page
  end
end
