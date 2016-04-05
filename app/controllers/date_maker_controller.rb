class DateMakerController < PrivateController

  def create
    times = params["date"].map do |dk, dv|
      next if dv.empty?
      params["time"].map do |tk, tv|
        next if tv.empty?
        ({date: Time.parse("#{dv} #{tv}"), meeting_uuid: params[:meeting_uuid]} rescue nil)
      end.compact
    end.compact.flatten

    # TODO: maybe is there a better way to handle this error
    # TODO: Better handlement
    # 1. make it in a transaction
    # 2. make it and catch every errors and returns them at the end
    errors = []
    r = times.map{|date|
      begin
        MeetingDate.create(date)
      rescue => e
        errors << "Cannot register this. Because of #{e.cause.message}"
        nil
      end
    }.compact
    render json: {errors: errors, data: r}
  end

  def destroy
    @meeting_date = MeetingDate.joins(:meeting).where(meetings: {user_id: current_user.id}).find(params[:meeting_date_id])
    @meeting_date.destroy
    head :no_content
  end


end
