# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.take

    if user&.authenticate(params[:password])
      sign_in(user)
      redirect_to admin_path
    else
      flash.now.alert = "Incorrect password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    cookies.delete(:signin)
    redirect_to root_path, status: :see_other
  end
end
