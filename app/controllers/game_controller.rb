class GameController < ApplicationController

  # if the user tries to access any of these pages while logged out, they will be asked to login, and redirected to the appropriate page after
  before_filter :signed_in_user
  
  def index
  end

  def buildings
  end
  
  def buildings_submit
    @current_user.building.residence += 1
    @current_user.building.save
    flash[:success] = "Built a Residence!"
    redirect_to buildings_path
  end
end
