class Website < ActiveRecord::Base
  has_many :actor_websites
  has_many :actors, through: :actor_websites
end
