class DateMakerController < PrivateController

  def create
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

  def destroy
    @meeting_date = MeetingDate.joins(:meeting).where(meetings: {user_id: current_user.id}).find(params[:meeting_id])
    @meeting_date.destroy
    head :no_content
  end


end
