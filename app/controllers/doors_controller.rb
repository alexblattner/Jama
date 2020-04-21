class DoorsController < ApplicationController
  before_action :set_door, only: [:show, :edit, :update, :destroy]
  include GamestatesHelper
  include HeroesHelper
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
  def open
    id=params[:id]
    @door=Door.find_by(id:id)
    next_l=JSON.parse(@door.next_levels).sample
    @gamestate=Gamestate.where({game_id: @door.game_id, user_id:session[:user_id]}).first
    @hero=Hero.find_by(id: @gamestate.hero_id)
    re=JSON.parse(@door.requirement)
    passed=true
    re.keys.each{
      |i|
      s=re[i]
      if s[0]==">"
        s[0]=''
        t=(['exp','hp','gold'].include?i)?@hero:stats_calc(@hero.exp,@hero.hp)
        if t[i]<=s.to_i
          passed=false
        end
      elsif s[0]=="="
        s[0]=''
        t=(['exp','hp','gold'].include?i)?@hero:stats_calc(@hero.exp,@hero.hp)
        if t[i]<=s.to_i
          passed=false
        end
      elsif s[0]=="<"
        s[0]=''
        t=(['exp','hp','gold'].include?i)?@hero:stats_calc(@hero.exp,@hero.hp)
        if t[i]<=s.to_i
          passed=false
        end
      end
    }
    if passed
      EventInstance.where({gamestate_id:@gamestate.id}).update(:progress=>"0")
      @gamestate.update(:level_id=>next_l)
      r=JSON.parse(@door.result)
      if r.is_a?(Hash)
        hero_update(r,@hero)
      end
      render json: @door.to_json(only: [:result])
    else
      render json: [0].to_json
    end
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

  def assignlevelforone
    @door_id = params['door_id']
    @game_id = params['game_id']
  end

  def levels_to_names door
    @names = Array.new
    if(door.next_levels.to_s.strip.length > 2)
      level_ids = JSON.parse(door.next_levels)
      level_ids.each do 
        |level_id| level = Level.find_by(id: level_id)
        @names.push(level.name)
      end
    end
    @names
  end
  helper_method :levels_to_names

  def queuelevel
    @game_id = params[:game_id]
    @level_id = params[:level_id]
    @door_id = params[:door_id]
    curr_door = Door.find_by(id: @door_id)
    curr_levels = Array.new
    len = curr_door.next_levels.to_s.strip.length
    
    #because the default JSON string is "[]"
    if(len > 2)
      curr_levels = JSON.parse(curr_door.next_levels)
    end
    curr_levels.push(@level_id)
    curr_door.next_levels = curr_levels.to_json
    level = Level.find_by(id: @level_id)
    if(curr_door.save)
      flash[:success] = "Great, " + level.name + " was added to the list"  
    end
    render 'assignlevelforone'
  end

  def dequeuelevel
    @game_id = params[:game_id]
    @door_id = params[:door_id]
    curr_door = Door.find_by(id: @door_id)
    len = curr_door.next_levels.to_s.strip.length
    
    #because the default JSON string is "[]"
    if(len <= 2)
      flash[:fail] = "No levels to remove"
    else
      curr_levels = JSON.parse(curr_door.next_levels)
      curr_level = curr_levels.pop
      curr_door = Door.find_by(id: curr_door)
      curr_door.next_levels= curr_levels.to_json
      if(curr_door.save)
        flash[:success] = "Great, " + curr_door.name + " was removed from the list"  
      end
    end
    render 'assignlevelforone'

  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_door
      @door = Door.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def door_params
      params.require(:door).permit(:name, :next_levels, :description, :image, :result, :requirement)
    end
end
