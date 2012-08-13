class PasswordResetsController < ApplicationController

  def new
    if signed_in?
      redirect_to edit_user_path(current_user)
    end
  end
  
  def create
    params[:email] = params[:email].downcase.strip    # my database stores all the emails in lowercase, the database is case sensitive but email addresses are not
    session[:bad_email] = params[:email]
    user = User.find_by_email(params[:email])   # according to the interwebs, find_by methods escape their own input, so this is not vulnerable to SQL injection
    if user   # account exists
      user.send_password_reset if user
      # from my testing, this output is not vulnerable to XSS even though I expect it to be, so I guess I just trust it for now
      # also, it should be impossible to create a username that could cause XSS anyway
      redirect_to login_path
      flash[:info] = "Email sent to " + wrap_text(user.email) + " with password reset instructions."
    else  # if email doesn't exist
      unless user
        flash.now[:error_field] = 'pwemail'
        if params[:email].blank?
          flash[:error_message] = 'Email is required'
        elsif !(params[:email] =~ VALID_EMAIL_REGEX)
          flash[:error_message] = 'Email address is not formatted properly (must be of the form name@foo.bar)'
        else
          flash[:error_message] = 'There is no account for the given email address'
        end
      end
      redirect_to resetpassword_path
    end
  end
  
  def edit
    expired = false
    @user = User.find_by_password_reset_token(params[:id])
    unless @user
      expired = true
    end
    if @user
      if @user.password_reset_sent_at < 2.hours.ago
        expired = true
      end
    end
    if expired
      redirect_to new_password_reset_path
      flash[:error] = "The password reset link that you used has expired.  Please resubmit this form for a fresh link."
    end
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path
      flash[:error] = "The password reset link that you used has expired.  Please resubmit this form for a fresh link."
    elsif @user.update_attributes(params[:user])
      session[:bad_email] = @user.email
      redirect_to login_path
      flash[:success] = "Password has been succesfully changed."
    else
      render :edit
    end
  end
end
