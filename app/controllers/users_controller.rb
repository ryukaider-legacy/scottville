class UsersController < ApplicationController

  before_filter :signed_in_user, except: [:new, :create]              # must be logged in for these pages
  before_filter :activation_redirect, only: [:show, :edit, :index]    # must be activated for these pages
  before_filter :correct_user,   only: [:edit, :update, :destroy]     # must be viewing pages for self to perform these actions
  before_filter :already_activated, only: [:activation, :activate, :activation_resend]    # can't access activation related pages if already activated
  
  def show
    @user = User.find(params[:id])
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
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.all
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
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
