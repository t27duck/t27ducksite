class SessionsController < ApplicationController
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_path, alert: "Too many sign in attempts. Try again later." }

  def new
  end

  def create
    user = User.take

    if user&.authenticate(params[:password])
      sign_in(user)
      redirect_to admin_path
    else
      flash.now.alert = "Incorrect password."
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    cookies.delete(:signin)
    reset_session
    redirect_to root_path, status: :see_other
  end
end
