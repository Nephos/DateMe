class MeetingMakerController < PrivateController
  def new
    @meeting = Meeting.new
    #redirect_to root_url, alert: "Not ready yet"
  end

  def create
    redirect_to root_url, alert: "Not ready yet"
  end

  def show
    @meeting = Meeting.eager_load(:users, :user_dates, :meeting_dates => :user_dates).find(params[:id])
    @meeting_date = MeetingDate.new
    #redirect_to root_url, alert: "Not ready yet"
  end
end
