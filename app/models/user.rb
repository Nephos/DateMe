class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_dates
  has_many :meeting_dates, through: :user_dates
  has_many :meetings, through: :meeting_dates

  def roles
    self.attributes["roles"].to_s.split(",")
  end

  def admin?
    roles.include? "admin"
  end

  NAME_MAX_LENGHT = 8
  def name
    self.email.split("@").first.first(NAME_MAX_LENGHT)
  end

  def owner?(obj)
    obj.user_id == self.id
  end

end
