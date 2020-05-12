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
    # @result_json['hp'] = "0"
    # @result_json['exp'] = "0"
    # @result_json['gold'] = "0"
    @req_json = Hash.new
    # @req_json['hp'] = ">0"
    # @req_json['rank'] = ">0" 
    # @req_json['gold'] = ">0"
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
    req = "{"
    if(!params['door_req_hp'].nil? && !(params['door_req_hp'].to_i == 0))
      req += "\"hp\":"
      req += "\"" + params['door_req_hp_operator'].to_s
      req += params['door_req_hp'] + "\""
    end
    if(!params['door_req_rank'].nil? && !(params['door_req_rank'].to_i == 0))
      if(req.length > 2)
        req += ", "
      end
      req += "\"rank\":"
      req += "\"" +params['door_req_rank_operator']
      req += params['door_req_rank'] + "\""
    end
    if(!params['door_req_gold'].nil? && !(params['door_req_gold'].to_i == 0))
      if(req.length > 2)
        req += ","
      end
      req+= "\"gold\":"
      req += "\"" + params['door_req_gold_operator']
      req += params['door_req_gold'] + "\""
    end
    req += "}"
    req
  end

  def createResultJSON params
    result = "{"
    if(!params['door_result_hp'].nil? && !(params['door_result_hp'].to_i == 0))
      result += "\"hp\":"
      result += params['door_result_hp'] 
    end
    
    if(!params['door_result_exp'].nil? && !(params['door_result_exp'].to_i == 0))
      if (result.length > 2)
        result +=","
      end
      result += "\"exp\":"
      result += params['door_result_exp'] 
    end
    if(!params['door_result_gold'].nil? && !(params['door_result_gold'].to_i == 0)) 
      if (result.length > 2)
        result +=","
      end
      result += "\"gold\":"
      result += params['door_result_gold']
    end
    result += "}"
    result
  end
  def has_this_door(lev, id)
    if(id == -1)
      return false
    end
    lev.doors
    json = JSON.parse(lev.doors)
    has = ""
    if json.detect{|c| c == id}
      has = "checked"
    end
    puts has
    has
  end
  helper_method :has_this_door

  def has_this_level lev
    if(@door.nil?)
      puts "door was nil"
      return ""
    end
    l = @door.next_levels
    json = JSON.parse(l)
    has = ""
    puts lev.id
    puts @door.next_levels
    if json.detect{|c| c == lev.id.to_s}
      puts "has this level"
      has = "checked"
    end
    puts has
    has
  end
  helper_method :has_this_level
  
  # POST /doors
  # POST /doors.json
  def create
    @prev_levels = params['prev_level_ids']
    @next_levels = params['next_level_ids']
    puts "params: !!!!!!!!!!!!!!!"
    puts params
    par = door_params.reject { |k,v| k == 'prev_level_ids' || k == 'next_level_ids' }
    nex = @next_levels.to_json
    puts @next_levels.to_json    
    @door = Door.new(door_params)
    @door.next_levels = @next_levels.to_json
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
      if params[:commit] == 'Finish this door and return to dashboard'
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
    @door.game_id = params[:game_id]
    @door.result = createResultJSON(params)
    if(!@door.door_image.attached?)
      @door.door_image.attach(io: File.open("app/assets/images/door1.jpg"), filename: "door1.jpg")
    end
    @door.image = @door.door_image.service_url
    @door.requirement = createRequirementJSON(params)
    if @door.update(door_params)
      #flash[:success] = "Great! Door updated."
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
      #flash[:success] = "Great, " + level.name + " was added to the list"  
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
      #flash[:fail] = "No levels to remove"
    else
      curr_levels = JSON.parse(curr_door.next_levels)
      curr_level = curr_levels.pop
      curr_door = Door.find_by(id: curr_door)
      curr_door.next_levels= curr_levels.to_json
      if(curr_door.save)
        #flash[:success] = "Great, " + curr_door.name + " was removed from the list"  
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
      params.require(:door).permit(:name, :game_id, :next_levels, :description, :image, :result, :requirement, :door_image)
    end
end
