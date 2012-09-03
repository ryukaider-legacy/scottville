class UsersController < ApplicationController

  before_filter :signed_in_user, except: [:new, :create]                                  # must be logged in for these pages
  before_filter :activation_redirect, only: [:show, :index]                               # must be activated for these pages
  before_filter :correct_user, only: [:update, :destroy]                                  # must be viewing pages for self to perform these actions
  before_filter :already_activated, only: [:activation, :activate, :activation_resend]    # can't access activation related pages if already activated
  
  def show
    @user = User.find_by_name(params[:id])
    unless @user
      redirect_to players_path
    end
  end
  
  def new
    redirect_to(root_path) unless !signed_in?
    @user = flash[:user] || User.new
    @focus_field = flash[:focus_field] ||'user_name'    # default focus
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save   # successful create
      building = @user.create_building(residence: "0", credit: "0", aether: "0", item: "0", stealth: "0", defense: "0")
      sign_in_temp @user
      @user.send_email_validation if @user
      redirect_to activation_path
    else    # failed to create a new account
      redirect_to(game_path) unless !signed_in?
      @focus_field ||= 'user_name'
      unless @user.errors[:name].any?
        @focus_field = 'user_email'
        unless @user.errors[:email].any?
          @focus_field = 'user_password'
        end
      end
      flash[:user] = @user
      flash[:focus_field] = @focus_field
      redirect_to signup_path unless signed_in?
    end
  end
  
  def account
    @user = flash[:user] || current_user
    @focus_field = flash[:focus_field] || 'current_password'
  end
  
  def update
    if @user.authenticate(params[:current_password])    # current password is correct
      if @user.update_attributes(params[:user])   # new password is valid
        flash[:success] = 'Password Changed'
        sign_in_temp @user
        redirect_to account_path
      else    # current password is right, but new password is invalid
        flash[:user] = @user
        redirect_to account_path
      end
    else    # current password is wrong
      flash[:error_field] = 'current_password'
      @focus_field = 'current_password'
      flash[:focus_field] = @focus_field
      if params[:current_password].blank?
        flash[:error_message] = 'You must enter your current password to change passwords.'
        redirect_to account_path
      else
        flash[:error_message] = 'Incorrect current password'
        redirect_to account_path
      end
    end
  end
  
  def index
    @users = User.all
  end
  
  def destroy
    if @user.authenticate(params[:current_password_delete])    # current password is correct
      User.find(params[:id]).destroy
      flash[:success] = 'Your account has been destroyed :('
      redirect_to root_path
    else    # current password is wrong
      flash[:error_field] = 'current_password_delete'
      @focus_field = 'current_password_delete'
      flash[:focus_field] = @focus_field
      if params[:current_password_delete].blank?
        flash[:error_message] = 'You must enter your current password to delete your account'
        redirect_to account_path
      else
        flash[:error_message] = 'Incorrect current password'
        redirect_to account_path
      end
    end
  end
  
  def activation
  end
  
  def activation_resend
    current_user.send_email_validation if current_user
    flash[:info] = "Activation email resent to " + wrap_text(current_user.email)
    redirect_to activation_path
  end
  
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def already_activated
      if current_user.email_validation
        redirect_to game_path
      end
    end
end
