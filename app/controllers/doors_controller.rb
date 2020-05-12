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
    @result_json = Hash.new
    @req_json = Hash.new
    @door.result = @result_json.to_json
    @door.requirement = @req_json.to_json
    arr = Array.new
    @door.next_levels = arr.to_json
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
    if requirements_passed(@hero,re)
      EventInstance.where({gamestate_id:@gamestate.id}).delete_all
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


  def get_result_json
    res = @result_json.to_json
    if(instance_variable_defined?("@door"))
      res = @door.result
    end
    result = JSON.parse(res)
    result
  end
  helper_method :get_result_json

  def get_req_json
    req = @req_json.to_json
    if(instance_variable_defined?("@door"))
      req = @door.requirement
    end
    requirement = JSON.parse(req)
    requirement
  end
  helper_method :get_req_json

  def createRequirementJSON params
    return Doors::Json.new(params).createRequirementJSON
  end

  def createResultJSON params
    return Doors::Json.new(params).createResultJSON
  end


  def has_this_door(lev, id)
    return Doors::Has.new(lev).this_door(id)
  end
  helper_method :has_this_door

  def has_this_level lev
    return Doors::Has.new(lev).this_level(@door)
  end
  helper_method :has_this_level
  
  # POST /doors
  # POST /doors.json
  def create
    @prev_levels = params['prev_level_ids']
    @next_levels = params['next_level_ids']
    
    par = door_params.reject { |k,v| k == 'prev_level_ids' || k == 'next_level_ids' }
    nex = @next_levels.to_json
    if(nex == "null")
        nex = Array.new
        nex = nex.to_json
    end
    @door = Door.new(door_params)
    @door.next_levels = nex
    
    @door.result = createResultJSON(params)
    @door.requirement = createRequirementJSON(params)
    if(!@door.door_image.attached?)
      @door.door_image.attach(io: File.open("app/assets/images/door1.jpg"), filename: "door1.jpg")
    end
    @door.image = @door.door_image.service_url
    if @door.save
      @door.save
      if(!@prev_levels.nil?)
        @prev_levels.each do
          |level| lev = Level.find(level)
          doors = Array.new
          len = lev.doors.to_s.strip.length
          if len > 2
            doors = JSON.parse(lev.doors)
          end
          doors.push(@door.id)
          lev.doors = doors.to_json
          lev.save
        end
      else
        #flash[:fail] = "You should add some previous levels to the connection"
      end 
      #flash[:success] = "Great! New door created."
      if params[:commit] == 'Finish this door'
        redirect_to leveldashboard_url(@door.game_id)
      else
        redirect_to adddoor_url(@door.game_id)
      end
    else
      redirect_to adddoor_url(@door.game_id)
  end
  end

  # PATCH/PUT /doors/1
  # PATCH/PUT /doors/1.json
  def update
    @prev_levels = params['prev_level_ids']
    @next_levels = params['next_level_ids']
    par = door_params.reject { |k,v| k == 'prev_level_ids' || k == 'next_level_ids' }
    nex = @next_levels.to_json
    if(nex == "null")
      nex = Array.new
      nex = nex.to_json
  end
    @door.next_levels = nex
    if(!@door.door_image.attached?)
      @door.door_image.attach(io: File.open("app/assets/images/door1.jpg"), filename: "door1.jpg")
    end
    @door.image = @door.door_image.service_url
    @door.requirement = createRequirementJSON(params)
    @door.result = createResultJSON(params)
    if @door.update(door_params)
      if(!@prev_levels.nil?)
        @prev_levels.each do
          |level| lev = Level.find(level)
          doors = Array.new
          len = lev.doors.to_s.strip.length
          if len > 2
            doors = JSON.parse(lev.doors)
          end
          doors.push(@door.id)
          lev.doors = doors.to_json
          lev.save
        end
      end
      if params[:commit] == 'Finish this door'
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
      params.require(:door).permit(:name, :game_id, :next_levels, :description, :image, :result, :requirement, :door_image)
    end
end
