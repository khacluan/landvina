class Attachment < ActiveRecord::Base
  attr_accessible :content_type
  has_many :assets, dependent: :destroy
end
