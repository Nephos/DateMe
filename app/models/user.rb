class User < ActiveRecord::Base
  NAME_MIN_LENGTH = 2
  NAME_MAX_LENGTH = 8

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_dates
  has_many :meeting_dates, through: :user_dates
  has_many :meetings, through: :meeting_dates

  validates :name, length: {in: NAME_MIN_LENGTH..NAME_MAX_LENGTH}, uniqueness: true
  validates :roles, null: false # TODO: add validation on the content

  before_save :name_fill
  def name_fill
    if self.name.to_s.empty?
      self.name = self.email.split("@").to_s.first(NAME_MAX_LENGTH)
    end
  end

  def admin?
    roles.include? "admin"
  end

  def owner?(obj)
    obj.user_id == self.id
  end

end
