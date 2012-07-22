class SessionsController < ApplicationController

  def new
    if signed_in?
      redirect_to game_path
    end
    @focus_field ||= 'session_email'    # default focus field
    session[:bad_email] ||= ""  # there's no bad input yet
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:bad_email] = ""
      if params[:remember_me]
        sign_in_permanent user
      else
        sign_in_temp user
      end
      redirect_back_or user
    else
      login_errors user   # see session helpers
      session[:bad_email] = params[:session][:email]   # save the user's bad input
      render 'new'
    end
  end

  def destroy
    session[:bad_email] = ""
    sign_out
    redirect_to root_path
  end
end
