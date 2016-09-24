class UserWebsite < ActiveRecord::Base
  belongs_to :user
  belongs_to :website
  validates :user, presence: :true
  validates :website, presence: :true
end
