class ActorWebsite < ActiveRecord::Base
  belongs_to :actor
  belongs_to :website
  validates :actor, presence: :true
  validates :website, presence: :true
end
