class Track < ActiveRecord::Base
  has_one :actor
  has_one :pageobject
  has_many :movements

end
