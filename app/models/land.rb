class Land < ActiveRecord::Base
  attr_accessible :land_position_text, :land_status, :price, :title, :avatar, :land_type, :location_latitude, :location_longitude, :location_address
  has_attached_file :avatar, :styles => { :medium => "244x180#", :thumb => "100x100>" }
  
end
