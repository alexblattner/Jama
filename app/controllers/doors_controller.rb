class DoorsController < ApplicationController
  before_action :set_door, only: [:show, :edit, :update, :destroy]

  # GET /doors
  # GET /doors.json
  def index
    @doors = Door.all
  end

  # GET /doors/1
  # GET /doors/1.json
  def show
  end
 
  # GET /doors/new
  def new
    @door = Door.new
    @door.game_id = params[:game_id]

  end

  # GET /doors/1/edit
  def edit
  end

  # POST /doors
  # POST /doors.json
  def create
    @door = Door.new(door_params)

    if @door.save
      flash[:success] = "Great! New door created."
      if params[:commit] == 'Finish this door and return to game logic'
        redirect_to creategamelogic_url(@door.game_id)
      else
        redirect_to adddoor_url(@door.game_id)
      end
    else
      render "new"
  end
  end

  # PATCH/PUT /doors/1
  # PATCH/PUT /doors/1.json
  def update
    if @door.update(door_params)
      flash[:success] = "Great! Door updated."
      if params[:commit] == 'Finish this door and return to dashboard'
        redirect_to leveldashboard_url(@door.game_id)
      else
        redirect_to adddoor_url(@door.game_id)
      end
    else
      render "edit"
    end
  end

  # DELETE /doors/1
  # DELETE /doors/1.json
  def destroy
    @door.destroy
    respond_to do |format|
      format.html { redirect_to doors_url, notice: 'Door was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_door
      @door = Door.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def door_params
      params.require(:door).permit(:name, :next_levels, :description, :door_image, :result, :requirement, :game_id)
    end
end
