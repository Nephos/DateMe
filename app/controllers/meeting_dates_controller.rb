class MeetingDatesController < PrivateController
  load_and_authorize_resource

  #before_action :set_meeting_date, only: [:show, :edit, :update, :destroy]

  # GET /meeting_dates
  # GET /meeting_dates.json
  def index
    @meeting_dates = MeetingDate.all
  end

  # GET /meeting_dates/1
  # GET /meeting_dates/1.json
  def show
  end

  # GET /meeting_dates/new
  def new
    @meeting_date = MeetingDate.new
  end

  # GET /meeting_dates/1/edit
  def edit
  end

  # POST /meeting_dates
  # POST /meeting_dates.json
  def create
    @meeting_date = MeetingDate.new(meeting_date_params)

    respond_to do |format|
      if @meeting_date.save
        format.html { redirect_to @meeting_date, notice: 'Meeting date was successfully created.' }
        format.json { render :show, status: :created, location: @meeting_date }
      else
        format.html { render :new }
        format.json { render json: @meeting_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meeting_dates/1
  # PATCH/PUT /meeting_dates/1.json
  def update
    respond_to do |format|
      if @meeting_date.update(meeting_date_params)
        format.html { redirect_to @meeting_date, notice: 'Meeting date was successfully updated.' }
        format.json { render :show, status: :ok, location: @meeting_date }
      else
        format.html { render :edit }
        format.json { render json: @meeting_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meeting_dates/1
  # DELETE /meeting_dates/1.json
  def destroy
    @meeting_date.destroy
    respond_to do |format|
      format.html { redirect_to meeting_dates_url, notice: 'Meeting date was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting_date
      @meeting_date = MeetingDate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_date_params
      params.require(:meeting_date).permit(:date, :meeting_id, :note)
    end
end
