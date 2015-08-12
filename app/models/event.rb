class Event < ActiveRecord::Base
  attr_accessor :_method

  belongs_to :user
  has_many :attendances
  has_many :comments

  validates :name, :location, presence: true
  validates_date :date, :on_or_after => lambda { Date.current }#:today
end
