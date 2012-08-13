class ActivateController < ApplicationController

  def edit
    @user = User.find_by_email_validation_token(params[:id])
    valid_activation_token
    if @user
    @user.email_validation = true
    @user.save!(validate: false)
    sign_in_temp @user
    flash[:success] = "Account successfully activated, welcome to " + game_name + "!"
    redirect_to game_path
    end
  end
  
  private
    def valid_activation_token
      unless @user
        redirect_to activation_path
        flash[:error] = 'The activation link that you used has expired.  Please resubmit this form for a fresh link.'
      end
    end
end
