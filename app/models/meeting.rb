class Meeting < ActiveRecord::Base
  acts_as_commentable
  has_many :meeting_dates, foreign_key: 'meeting_uuid', primary_key: 'uuid', :dependent => :destroy # requires to remove the meeting_dates.user_dates
  has_many :user_dates, through: 'meeting_dates'
  belongs_to :user
  has_many :users, through: :user_dates

  delegate :name, to: :user, prefix: true

  before_create :generate_uuid
  def generate_uuid
    self.uuid = UUID.new.generate
  end


  before_save :default_description
  def default_description
    self.description = "no description provided" if self.description.to_s.size == 0
  end

  validates :name, absence: false, length: { min: 4 }, allow_blank: false
  validates :description, absence: false, allow_blank: false

end
