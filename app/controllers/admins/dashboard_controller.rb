class Admins::DashboardController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin!
  def index
  end

  def home
  end
end
