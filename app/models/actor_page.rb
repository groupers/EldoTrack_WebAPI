class ActorPage < ActiveRecord::Base
  belongs_to :actor
  belongs_to :page
  validates :actor, presence: :true
  validates :page, presence: :true
end
