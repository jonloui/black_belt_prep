class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  # has_many :users
  # has_many :events
end
