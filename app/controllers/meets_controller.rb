class MeetsController < ApplicationController
  before_action :set_meet, only: [:show, :edit, :update, :destroy]

  # GET /meets
  # GET /meets.json
  def index
    @meets = Meet.all
  end

  # GET /meets/1
  # GET /meets/1.json
  def show
  end

  # GET /meets/new
  def new
    @meet = Meet.new
  end

  # GET /meets/1/edit
  def edit
  end

  # POST /meets
  # POST /meets.json
  def create
    @meet = Meet.new(meet_params)

    respond_to do |format|
      if @meet.save
        format.html { redirect_to @meet, notice: 'Meet was successfully created.' }
        format.json { render :show, status: :created, location: @meet }
      else
        format.html { render :new }
        format.json { render json: @meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meets/1
  # PATCH/PUT /meets/1.json
  def update
    respond_to do |format|
      if @meet.update(meet_params)
        format.html { redirect_to @meet, notice: 'Meet was successfully updated.' }
        format.json { render :show, status: :ok, location: @meet }
      else
        format.html { render :edit }
        format.json { render json: @meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meets/1
  # DELETE /meets/1.json
  def destroy
    @meet.destroy
    respond_to do |format|
      format.html { redirect_to meets_url, notice: 'Meet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meet
      @meet = Meet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meet_params
      p = params.require(:meet).permit(:name, :description, :end_at, :dates)
      p["dates"] = JSON.parse(p["dates"]) if p["dates"]
      p
    end
end
