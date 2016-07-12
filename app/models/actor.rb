class Actor < ActiveRecord::Base
  validates :token, presence: :true, uniqueness: true
  has_many :pages, through: :actor_pages
  has_many :actor_pages
  has_many :tracks

  auto_strip_attributes :token, squish: true
end
