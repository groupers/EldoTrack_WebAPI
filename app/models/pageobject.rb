class Pageobject < ActiveRecord::Base
  belongs_to :page
  has_many :tracks
  has_many :movements, through: :tracks
end
