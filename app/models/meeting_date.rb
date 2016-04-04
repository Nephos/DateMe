class MeetingDate < ActiveRecord::Base
  belongs_to :meeting
  has_many :user_dates, :dependent => :delete_all # no dependencies

  def date_formated
    self.date.strftime("%d %b %Y, %Hh%M")
  end

  def attributes
    super.merge("date_formated" => self.date_formated)
  end

end
