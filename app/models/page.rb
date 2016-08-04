class Page < ActiveRecord::Base
  has_many :pageobjects
  has_many :user_pages
  has_many :users, through: :user_pages
  has_many :actor_pages
  has_many :actors, through: :actor_pages
end
