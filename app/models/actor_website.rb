class ActorWebsite < ActiveRecord::Base
  belongs_to :actor
  belongs_to :website
end
