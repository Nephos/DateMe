class MeetingMakerController < PrivateController
  def new
    redirect_to root_url, alert: "Not ready yet"
  end

  def create
    redirect_to root_url, alert: "Not ready yet"
  end

  def show
    redirect_to root_url, alert: "Not ready yet"
  end
end
