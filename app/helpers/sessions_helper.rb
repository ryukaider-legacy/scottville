module SessionsHelper

  def sign_in_permanent(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end
  
  def sign_in_temp(user)
    cookies[:remember_token] = user.remember_token
    self.current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token]
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def set_current_user
    @user = current_user
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to login_path
      flash[:info] = "Please log in."
    end
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || game_path)
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def activation_redirect
    if signed_in?
      unless current_user.email_validation
        flash[:error] = 'This account has not yet been activated.  Please check your email for the activation link or click the button below to resend it.'
        redirect_to activation_path
      end
    end
  end
  
  VALID_EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  def login_errors(user)
    @focus_field = 'session_email'
    @error_message = ""
    unless user
      if params[:session][:email].blank?
        @error_message = 'Email is required'
      elsif !(params[:session][:email] =~ VALID_EMAIL_REGEX)
        @error_message = 'Email address is not formatted properly (must be of the form name@foo.bar)'
      else
        link = "<a href=\"#{url_for(signup_path)}\">#{"create this account"}</a>"
        @raw_error_message = "There is no account for the given email address.<br>Do you want to #{link}?"
        flash[:email] = params[:session][:email]
      end
    end
    if user
      @focus_field = 'session_password'
      @error_message = 'Incorrect password'
    end
  end
  
  def bad_email=(email)
    @bad_email = email
  end
end
