class MeetingDate < ActiveRecord::Base
  belongs_to :meeting, foreign_key: 'meeting_uuid', primary_key: 'uuid'
  has_many :user_dates, :dependent => :delete_all # no dependencies
  has_many :users, through: :user_dates

  def date_formated
    self.date.strftime("%d %b %Y, %H:%M")
  end

  def attributes
    if super["date"]
      super.merge("date_formated" => self.date_formated)
    else
      super
    end
  end

end
