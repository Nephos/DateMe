class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_dates
  has_many :meeting_dates, through: :user_dates

  def roles
    self.attributes["roles"].to_s.split(",")
  end

  def admin?
    roles.include? "admin"
  end
end
