class UserPage < ActiveRecord::Base
  belongs_to :user
  belongs_to :page
  validates :user, presence: :true
  validates :page, presence: :true
end
