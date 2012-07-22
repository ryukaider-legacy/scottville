class ActivateController < ApplicationController

  def edit
    @user = User.find_by_email_validation_token(params[:id])
    @user.email_validation = true
    @user.save!(validate: false)
    sign_in_temp @user
    flash[:success] = "Account successfully activated, welcome to " + game_name + "!"
    redirect_to game_path
  end
end
