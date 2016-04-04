class MeetingDate < ActiveRecord::Base
  belongs_to :meeting
  has_many :user_dates, :dependent => :delete_all # no dependencies

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
