class LandsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  include ApplicationHelper
  
  def index
    load_data Land, {per_page: 10}
    render :layout => false
  end

  def new
    @land = Land.new
    render :layout => false
  end
  
  def create
    @land = Land.new(params[:land])
    if @land.save
      load_data Land
      render :action => 'index', :layout => false
    else
      render :action => 'edit', :layout =>  false
    end
  end

  def edit
    @land = Land.find(params[:id])
    render :layout => false
  end
  
  def update
    @land = Land.find(params[:id])
    if @land.update_attributes(params[:land])
      load_data Land
      render :action => 'index', :layout => false
    else
      render :action => 'edit', :layout => false
    end
  end
  
  def destroy
    @land = Land.find(params[:id])
    @land.destroy
    load_data Land
    render :action => 'index', :layout => false
  end
end
