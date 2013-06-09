class ClientsController < ApplicationController
  include ApplicationHelper
    
  def index
    load_data Land, {where: {land_type: params[:type]}}
    render :layout => false
  end
  
  def home
    render :layout => false if request.xhr?
  end
  
end