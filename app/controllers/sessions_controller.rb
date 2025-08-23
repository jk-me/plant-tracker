class SessionsController < ApplicationController
  def create
    # Placeholder for login logic
    account = params[:account]
    password = params[:password]
    # Add authentication logic here
    redirect_to root_path, notice: "Logged in as #{account}"
  end
end
