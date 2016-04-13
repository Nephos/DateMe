class SubscriptionMakerController < PrivateController

  # subscribe
  def create
    @meeting = Meeting.find_by(uuid: params[:meeting_uuid])
    meeting_date_ids = @meeting.meeting_dates.pluck(:id)
    return redirect_to(meeting_share_path(@meeting.uuid), alert: "You cannot subscribe to an empty poll") if meeting_date_ids.size.zero?
    data = meeting_date_ids.map{|meeting_date_id|
      {user_id: current_user.id, meeting_date_id: meeting_date_id}
    }
    # The following code comes from the 90' !!
    # TODO: move it into the model
    begin
      n = UserDate.mass_insert(data).cmd_tuples
      redirect_to({action: :show, controller: :meeting_maker}, {notice: "Added to the poll, and #{n} vote#{n>1??s:nil} prepared for you"})
    rescue ActiveRecord::RecordNotUnique
      redirect_to({action: :show, controller: :meeting_maker}, {notice: "Cannot subscribe to this poll, you're already part."})
    end
  end

  # unsubscribe
  def destroy
    n = UserDate.joins(meeting_date: :meeting).where(meeting_dates: {meeting_uuid: params[:meeting_uuid]}, user: current_user).delete_all
    redirect_to({action: :show, controller: :meeting_maker}, {notice: "Removed from the poll, and #{n} vote#{n>1??s:nil} deleted"})
  end

end
