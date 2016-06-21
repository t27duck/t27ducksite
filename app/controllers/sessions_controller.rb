class SessionsController < ApplicationController
  before_action :require_no_login, only: [:new, :create]
  before_action :require_login, only: :destroy

  def new
  end

  def create
    if StupidlySimpleAuthentication.authenticate(params[:password])
      cookies.signed[:token] = StupidlySimpleAuthentication.session_token
      redirect_to root_path
    else
      render action: :new
    end
  end

  def destroy
    cookies.delete(:token)
    redirect_to root_path
  end
end
