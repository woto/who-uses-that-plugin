class ApplicationsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :application
end
