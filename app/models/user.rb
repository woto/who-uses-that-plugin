class User < ActiveRecord::Base
  #has_many :owned_applications, :class_name => "Application"
  #has_many :applications
  has_many :applications_users
  has_many :applications, :through => :applications_users
  has_one :application
  validates_uniqueness_of :name
end
