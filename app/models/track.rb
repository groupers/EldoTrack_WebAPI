class Track < ActiveRecord::Base
  belongs_to :actor
  has_one :pageobject
  has_many :movements

end
