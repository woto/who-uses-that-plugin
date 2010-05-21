class Plugin < ActiveRecord::Base
  has_and_belongs_to_many :applications
end
