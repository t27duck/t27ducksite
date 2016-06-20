class SessionController < ApplicationController
  def new
  end

  def create
    if StupidlySimpleAuthentication.autenticate(params[:password])
      cookies.signed[:token] = StupidlySimpleAuthentication.session_token
    else
      render action: :new
    end
  end

  def destroy
    cookies.signed[:token] = nil
    redirect_to root_path
  end
end
