class MeetingMakerController < PrivateController

  def index
    #@meetings = Meeting.where(user: current_user).order(updated_at: 'desc').paginate(:page => params[:page])
    #@meetings = Meeting.joins("JOIN meeting_dates ON meeting_dates.meeting_uuid = meetings.uuid LEFT OUTER JOIN user_dates ON meeting_dates.id = user_dates.meeting_date_id").where(["WHERE user_dates.user_id = ? OR meetings.user_id = ?", current_user.id, current_user.id]).uniq
    @meetings = Meeting.joins("JOIN meeting_dates ON meeting_dates.meeting_uuid = meetings.uuid LEFT OUTER JOIN user_dates ON meeting_dates.id = user_dates.meeting_date_id").where(
      ["user_dates.user_id = :uid OR meetings.user_id = :mid ", {uid: current_user.id, mid: current_user.id}]).uniq.order(updated_at: 'desc').paginate(:page => params[:page])
  end

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
      redirect_to meeting_share_path(@meeting.uuid)
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  def show
    load_share(params[:meeting_uuid])
    #redirect_to root_url, alert: "Not ready yet"
  end

  def update
    @meeting = Meeting.where(user: current_user).find_by(uuid: params[:meeting_uuid])
    if @meeting.update(meeting_params)
      render json: @meeting, status: :ok
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  private
  def load_share(uuid)
    @meeting = Meeting.eager_load(:users, :user_dates, :meeting_dates => :user_dates).find_by(uuid: uuid)
    raise ActiveRecord::RecordNotFound if @meeting.nil?
    @meeting_date = MeetingDate.new
    @comments = @meeting.comments.last(5)
    @comment = Comment.new
  end

  def meeting_params
    params.require(:meeting).permit(:name, :description, :end_at)
  end

end
