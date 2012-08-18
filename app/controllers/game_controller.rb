class GameController < ApplicationController

  before_filter :signed_in_user         # user must be logged in
  before_filter :activation_redirect    # user must be activated
  
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
