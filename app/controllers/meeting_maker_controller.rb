class MeetingMakerController < PrivateController
  def new
    @meeting = Meeting.new
    #redirect_to root_url, alert: "Not ready yet"
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.user = current_user
    if @meeting.save
      #load_share(@meeting.id)
      #render :show, status: :created, location: share_meetings_path(@meeting)
      redirect_to share_meetings_path(@meeting)
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  def show
    load_share(params[:id])
    #redirect_to root_url, alert: "Not ready yet"
  end

  def add_date
    times = params["date"].map do |dk, dv|
      next if dv.empty?
      params["time"].map do |tk, tv|
        next if tv.empty?
        ({date: Time.parse("#{dv} #{tv}"), meeting_id: params[:meeting_id]} rescue nil)
      end.compact
    end.compact.flatten
    r = MeetingDate.create(times)
    render json: r
  end

  def subscribe
    @meeting = Meeting.find(params[:id])
    meeting_date_ids = @meeting.meeting_dates.pluck(:id)
    UserDate.create(meeting_date_ids.map{|meeting_date_id| {user_id: current_user.id, meeting_date_id: meeting_date_id} })
    redirect_to action: :show
  end

  def unsubscribe
    UserDate.joins(meeting_date: :meeting).where(meeting_dates: {meeting_id: params[:id]}, user: current_user).delete_all
    redirect_to action: :show
  end

  private
  def load_share(id)
    @meeting = Meeting.eager_load(:users, :user_dates, :meeting_dates => :user_dates).find(id)
    @meeting_date = MeetingDate.new
  end

  def meeting_params
    params.require(:meeting).permit(:name, :description, :end_at)
  end

end
