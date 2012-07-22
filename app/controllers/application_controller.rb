class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  include ActionView::Helpers::TextHelper
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
