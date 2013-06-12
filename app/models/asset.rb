class Asset < ActiveRecord::Base
  attr_accessible :attachment_id, :file
  has_attached_file :file
end
