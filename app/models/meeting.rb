class Meeting < ActiveRecord::Base
  acts_as_commentable
  has_many :meeting_dates, foreign_key: 'meeting_uuid', primary_key: 'uuid', :dependent => :destroy # requires to remove the meeting_dates.user_dates
  has_many :user_dates, through: 'meeting_dates'
  belongs_to :user
  has_many :users, -> { distinct }, through: :user_dates

  delegate :name, to: :user, prefix: true

  before_create :generate_uuid
  def generate_uuid
    self.uuid = UUID.new.generate
  end

  before_save :default_description
  def default_description
    self.description = "no description provided" if self.description.to_s.size == 0
  end

  validates :name, absence: false, allow_blank: false
  validates :name, length: {in: 4..64}, uniqueness: true
  validates :description, absence: false, allow_blank: false

  scope :owned, -> (current_user) {
    joins("JOIN meeting_dates ON meeting_dates.meeting_uuid = meetings.uuid LEFT OUTER JOIN user_dates ON meeting_dates.id = user_dates.meeting_date_id").where(
    ["user_dates.user_id = :uid OR meetings.user_id = :mid ", {uid: current_user.id, mid: current_user.id}]
    ).uniq
  }

  scope :full_load, -> () {
    eager_load(:users, :user_dates, :meeting_dates => :user_dates)
  }

end
