class UsersController < ApplicationController
  # check for user being signed in before editing/updating a user, or viewing the list of all users
  before_filter :signed_in_user, only: [:index, :edit, :update]
  # check that the user being edited is the same as the user logged in, when editing or updating a user
  before_filter :correct_user,   only: [:edit, :update, :destroy]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    redirect_to(root_path) unless !signed_in?
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      building = @user.create_building(residence: "0", credit: "0", aether: "0", item: "0", stealth: "0", defense: "0")
      sign_in @user
      flash[:success] = "Welcome to " + game_name
      redirect_to @user
    else
      redirect_to(game_path) unless !signed_in?
      render 'new' unless signed_in?
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
  
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
