class Meeting < ActiveRecord::Base
  has_many :meeting_dates, foreign_key: 'meeting_uuid', primary_key: 'uuid', :dependent => :destroy # requires to remove the meeting_dates.user_dates
  has_many :user_dates, through: 'meeting_dates'
  belongs_to :user
  has_many :users, through: :user_dates

  delegate :name, to: :user, prefix: true

  before_create :generate_uuid
  def generate_uuid
    self.uuid = UUID.new.generate
  end
end
