class ClientsController < ApplicationController
  include ApplicationHelper
    
  def index
    load_data Land, {where: {land_type: params[:type]}}
    render :layout => false
  end
  
  def home
    render :layout => false if request.xhr?
  end
  
  
  def show_map
    @land = Land.find(params[:id])
    render :partial => '/clients/show_map', locals:{land: @land} ,layout: false
  end
  
  def land_detail
    @land = Land.find(params[:id])
    render :partial => '/clients/show_land_detail', :locals => {land: @land}
  end
end