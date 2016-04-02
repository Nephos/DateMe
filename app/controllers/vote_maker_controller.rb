class VoteMakerController < PrivateController
  before_action :set_user_date, only: [:show, :update, :destroy]

  def show
    render json: @user_date
  end

  def create
    @user_date = UserDate.new
    @user_date.user_id = current_user.id
    @user_date.meeting_date_id = params[:user_date][:meeting_date_id]
    @user_date.state = params[:user_date][:state]

    if @user_date.save
      render json: @user_date, status: :created
    else
      render json: @user_date.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user_date.update(vote_params)
      render json: @user_date, status: :ok
    else
      render json: @user_date.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_dates/1
  # DELETE /user_dates/1.json
  def destroy
    @user_date.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_date
      @user_date = UserDate.where(user_id: current_user.id).find(params[:id] || params[:user_date_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vote_params
      params.require(:user_date).permit(:state)
    end
end
