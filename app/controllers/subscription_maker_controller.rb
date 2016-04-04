class SubscriptionMakerController < PrivateController

  # subscribe
  def create
    @meeting = Meeting.find(params[:meeting_id])
    meeting_date_ids = @meeting.meeting_dates.pluck(:id)
    return redirect_to(meeting_share_path(@meeting), alert: "You cannot subscribe to an empty poll") if meeting_date_ids.size.zero?
    data = meeting_date_ids.map{|meeting_date_id| {user_id: current_user.id, meeting_date_id: meeting_date_id} }
    # The following code comes from the 90' !!
    current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    default_state = nil
    sql_query_mass_insert = "INSERT INTO user_dates (\"user_id\", \"meeting_date_id\", \"updated_at\", \"created_at\", \"state\") VALUES "
    sql_query_mass_insert += data.map {|row| "(#{row[:user_id]}, #{row[:meeting_date_id]}, '#{current_time}', '#{current_time}', '#{default_state}')" }.join(", ")
    n = ActiveRecord::Base.transaction { UserDate.connection.execute sql_query_mass_insert }.cmd_tuples
    redirect_to({action: :show, controller: :meeting_maker}, {notice: "Added to the poll, and #{n} vote#{n>1??s:nil} prepared for you"})
  end

  # unsubscribe
  def destroy
    n = UserDate.joins(meeting_date: :meeting).where(meeting_dates: {meeting_id: params[:meeting_id]}, user: current_user).delete_all
    redirect_to({action: :show, controller: :meeting_maker}, {notice: "Removed from the poll, and #{n} vote#{n>1??s:nil} deleted"})
  end

end
