class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end
  # GET /events/new
  def new
    @event = Event.new
    @event.game_id = params[:game_id]
    @result_json = Hash.new
    @result_json['attack'] = Hash.new
    @result_json['death'] = Hash.new
    # @result_json['hp'] = "0"
    # @result_json['exp'] = "0"
    # @result_json['gold'] = "0"
    # @result_json['attack']['hp'] = "0"
    # @result_json['attack']['exp'] = "0"
    # @result_json['attack']['gold'] = "0"
    # @result_json['death']['hp'] = "0"
    # @result_json['death']['exp'] = "0"
    # @result_json['death']['gold'] = "0"
    @event.result = @result_json.to_json
    # @requirement_json = Hash.new
    # @requirement_json['hp'] = ">0"
    # @requirement_json['rank'] = ">0"
    # @requirement_json['gold'] = ">0"
    @event.requirement = @requirement_json.to_json
  end

  def add_to_level
    
  end 
  # GET /events/1/edit
  def edit
  end
  
  
  def get_json
    res = @result_json.to_json
    if(instance_variable_defined?("@event"))
      res = @event.result
    end
    result = JSON.parse(res)
    result
  end
  helper_method :get_json

  #combine this with above
  def get_req_json
    req = @requirement_json.to_json
    if(instance_variable_defined?("@event"))
      req = @event.requirement
    end
    req = JSON.parse(req)
    req
  end
  helper_method :get_req_json

  def createRequirementJSON params
    req = "{"
    if(!params['event_req_hp'].nil? && !(params['event_req_hp'].to_i == 0))
      req += "\"hp\":"
      req += "\"" + params['event_req_hp_operator'].to_s
      req += params['event_req_hp'] + "\""
    end
    if(!params['event_req_rank'].nil? && !(params['event_req_rank'].to_i == 0))
      if(req.length > 2)
        req += ","
      end
      req += "\"rank\":"
      req += "\"" +params['event_req_rank_operator']
      req += params['event_req_rank'] + "\""
    end
    if(!params['event_req_gold'].nil? && !(params['event_req_gold'].to_i == 0))
      if(req.length > 2)
        req += ","
      end
      req += "\"gold\":"
      req += "\"" + params['event_req_gold_operator']
      req += params['event_req_gold'] + "\""
    end
    req += "}"
    req
  end
  #turns hp, exp, and gold into the JSON required for result
  def createDirectJSON params
    result = "{"
    if(!params['hp'].nil? && !(params['hp'].to_i == 0))
      result += "\"hp\":"
      result += params['hp'] 
    end
    if(!params['exp'].nil? && !(params['exp'].to_i == 0))
      if(result.length > 2)
        result += ","
      end
      result += "\"exp\":"
      result += params['exp'] 
    end
    if(!params['gold'].nil? && !(params['gold'].to_i == 0))
      if(result.length > 2)
        result += ","
      end
      result += "\"gold\":"      
      result += params['gold']
    end
    result += "}"
    result
  end

  # "[ "hp": 30, "attack": ["hp":10, "exp":0, "gold":10], death: ["hp":10, "exp":0, "gold":10]]"
  # "events"=>"fight", "enemy_hp"=>"123", "enemy_damage"=>"4", "enemy_damage_hp"=>"3",
  # "enemy_damage_exp"=>"1", "enemy_exp"=>"2",
  # "enemy_gold_drop"=>"2", "enemy_hp_drop"=>"4", "hp"=>""
  
  def createFightJSON params
    result = ""
    result += "{\"hp\":"
    if(params['enemy_hp'].nil?)
      result += ""
    else
      result += params['enemy_hp']
    end
    result += ", \"attack\": { \"hp\":"
    if(params['enemy_attack_hp'].nil?)
      result += ""
    else
      result += params['enemy_attack_hp'] 
    end
    result += ", \"exp\":"
    if(params['enemy_attack_exp'].nil?)
      result += ""
    
    else
      result += params['enemy_attack_exp'] 
    end
    result += ", \"gold\":"
    if(params['enemy_attack_gold'].nil?)
      result += ""
    
    else
      result += params['enemy_attack_gold'] 
    end
    # "death" :["hp": 1, "exp": 1, "gold": 1]
    result += "}, \"death\": {\"hp\":"
    if(params['enemy_death_hp'].nil?)
      result += ""
    
    else
      result += params['enemy_death_hp'] 
    end
    result += ", \"exp\":"
    if(params['enemy_death_exp'].nil?)
      result += ""
    else
      result += params['enemy_death_exp'] 
    end
    result += ", \"gold\":"
    if(params['enemy_death_gold'].nil?)
      result += ""
    else
      result += params['enemy_death_gold'] 
    end
    result += "}}"
    result
  end
  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.event_type = params['event_type']
    @event.game = Game.find(event_params[:game_id])
    @event.image = @event.event_image.service_url
    if @event.event_type == "fight"
      @event.result = createFightJSON(params)
    else
      @event.result = createDirectJSON(params)
    end
    # @event.image = url_for(@event.event_image)
    # puts @event.image
    @result_json = @event.result
    @event.requirement = createRequirementJSON(params)
    @requirement_json = @event.requirement
    if @event.save
      flash[:success] = "Get new event created."
      @event.image = url_for(@event.event_image)
      if params[:commit] == 'Save & Finish'
        redirect_to leveldashboard_url(@event.game_id)
      else
        redirect_to addevent_url(@event.game_id)
      end
    else
      render "new"
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    if params['event_type'] == "fight"
      @event.result = createFightJSON(params)
    else
      @event.result = createDirectJSON(params)
    end
    @result_json = @event.result
    @event.image = @event.attachment_url

    @event.requirement = createRequirementJSON(params)
    if @event.update(event_params)
      flash[:success] = "Successfully updated event."
      if params[:commit] == 'Save & Finish'
        redirect_to leveldashboard_url(@event.game_id)
      else
        redirect_to addevent_url(@event.game_id)
      end
    else
      render "edit"
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :result, :description, :event_type, :image, :game_id, :requirement, :event_image)
    end
end
