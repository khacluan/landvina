class DashboardController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin!
  def index
  end

  def home
    render :layout => false
  end
end
