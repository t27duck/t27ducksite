class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_path, alert: "Too many sign in attempts. Try again later." }

  def new
  end

  def create
    if (user = User.authenticate_by(username: "admin", password: params[:password]))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      flash.now.alert = "Incorrect password."
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, status: :see_other
  end
end
