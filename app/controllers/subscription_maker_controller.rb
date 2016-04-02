class SubscriptionMakerController < PrivateController

  # subscribe
  def create
    @meeting = Meeting.find(params[:meeting_id])
    meeting_date_ids = @meeting.meeting_dates.pluck(:id)
    UserDate.create(meeting_date_ids.map{|meeting_date_id| {user_id: current_user.id, meeting_date_id: meeting_date_id} })
    redirect_to action: :show, controller: :meeting_maker
  end

  # unsubscribe
  def destroy
    n = UserDate.joins(meeting_date: :meeting).where(meeting_dates: {meeting_id: params[:meeting_id]}, user: current_user).delete_all
    redirect_to({action: :show, controller: :meeting_maker}, {notice: "Removed from the poll, and #{n} vote deleted"})
  end

end
