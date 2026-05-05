class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ show create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to ENV["REACT_ORIGIN"], alert: "Try again later." }


  def create
    if user = User.authenticate_by(params.require(:user).permit(:email_address, :password))
      start_new_session_for user
      respond_to do |format|
        format.html { redirect_to after_authentication_url }
        format.json { render json: { user: user }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to login_path, alert: "Try another email address or password." }
        format.json { render json: { success: false, error: "Invalid email or password." }, status: :unauthorized }
      end
    end
  end

  def show
    authenticated?
    if Current.user
      render json: { user:
        { id: Current.user.id, email_address: Current.user.email_address }
        }, status: :ok
    else
      render json: { user: nil }, status: :ok
    end
  end

  def destroy
    terminate_session
    respond_to do |format|
      format.html { redirect_to login_path, notice: "You have been logged out." }
      format.json { render json: { success: true }, status: :ok }
    end
  end
end
