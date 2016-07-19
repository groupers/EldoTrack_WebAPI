class Track < ActiveRecord::Base
  belongs_to :actor
  belongs_to :pageobject
  has_many :movements

end
