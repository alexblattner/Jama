class LevelsController < ApplicationController
  before_action :set_level, only: [:show, :edit, :update, :destroy]
  # GET /levels
  # GET /levels.json
  def index
    @levels = Level.all
  end

  # GET /levels/1
  # GET /levels/1.json
  def show
  end

  def dashboard
    @game_id= params[:game_id]
  end
  # GET /levels/new
  def new
    @level = Level.new
    @level.game_id = params[:game_id]
  
  end

  # GET /levels/1/edit
  def edit
  end
  
  def doors
    if params.has_key? "level"
      l=Level.find_by(id: params['level'])
      arr=JSON.parse(l.doors)
      if arr.length>0
        i=1
        w="id='#{arr[0]}'"
        while i<arr.length
          w+=" or id='#{arr[i]}'"
          i+=1
        end
        ar=[1]
        d=Door.where(w)
        render json: d
      end
    end
  end

  def organizeevents
    puts "************"
    puts params
    @level = Level.find_by(id: params['level_id'])
    @game = Game.find_by(id: params['game_id'])
    render 'edit'
    puts "************"
  end
  # POST /levels
  # POST /levels.json
  def create
    @level = Level.new(level_params)
    @level.game = Game.find(level_params[:game_id])
    if @level.save
        flash[:success] = "Great! New level created."
        if params[:commit] == 'Create this level'
          redirect_to leveldashboard_url(@level.game_id)
        else
          redirect_to addlevel_url(@level.game_id)
        end
      else
        render "new"
    end
end
  # PATCH/PUT /levels/1
  # PATCH/PUT /levels/1.json
  def update
    respond_to do |format|
      if @level.update(level_params)
        format.html { redirect_to @level, notice: 'Level was successfully updated.' }
        format.json { render :show, status: :ok, location: @level }
      else
        format.html { render :edit }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /levels/1
  # DELETE /levels/1.json
  def destroy
    @level.destroy
    respond_to do |format|
      format.html { redirect_to levels_url, notice: 'Level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_level
      @level = Level.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def level_params
      params.require(:level).permit(:name, :event_id, :game_id, :doors, :description, :image)
    end
end
