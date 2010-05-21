class Application < ActiveRecord::Base
  has_and_belongs_to_many :plugins
  #has_many :users
  #has_many :owner, :class_name => "User"
  belongs_to :user
  has_many :applications_users
  has_many :users, :through => :applications_users
  validates_uniqueness_of :name
end
