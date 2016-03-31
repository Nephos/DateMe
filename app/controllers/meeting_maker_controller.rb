class MeetingMakerController < PrivateController
  def new
    @meeting = Meeting.new
    #redirect_to root_url, alert: "Not ready yet"
  end

  def create
    redirect_to root_url, alert: "Not ready yet"
  end

  def show
    @meeting = Meeting.find(params[:id])
    #redirect_to root_url, alert: "Not ready yet"
  end
end
