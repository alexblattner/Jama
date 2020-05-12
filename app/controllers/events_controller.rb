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
    @event.result = @result_json.to_json
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

  #turns hp, exp, and gold into the JSON required for result

  # "[ "hp": 30, "attack": ["hp":10, "exp":0, "gold":10], death: ["hp":10, "exp":0, "gold":10]]"
  # "events"=>"fight", "enemy_hp"=>"123", "enemy_damage"=>"4", "enemy_damage_hp"=>"3",
  # "enemy_damage_exp"=>"1", "enemy_exp"=>"2",
  # "enemy_gold_drop"=>"2", "enemy_hp_drop"=>"4", "hp"=>""
  def createJSON params, event_type
    if event_type == "fight"
      return Events::Json.new(params).createFightJSON
    else
      return Events::Json.new(params).createDirectJSON
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.event_type = params['event_type']
    @event.game = Game.find(event_params[:game_id])
    if(!@event.event_image.attached?)
      @event.event_image.attach(io: File.open("app/assets/images/fireball.jpg"), filename: "fireball.jpg")
    end
    @event.image = @event.event_image.service_url
    @event.result = createJSON(params, @event.event_type)
    @result_json = @event.result
    @event.requirement = Events::Json.new(params).createRequirementJSON
    @requirement_json = @event.requirement
    if @event.save
      flash[:success] = "Get new event created."
      @event.image = url_for(@event.event_image)
      if params[:commit] == 'Finish This Event'
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
    @event.result = createJSON(params, @event.event_type)

    @result_json = @event.result
    if(!@event.event_image.attached?)
      @event.event_image.attach(io: File.open("app/assets/images/fireball.jpg"), filename: "fireball.jpg")
    end
    @event.image = @event.event_image.service_url
    @event.requirement = Events::Json.new(params).createRequirementJSON
    if @event.update(event_params)
      flash[:success] = "Successfully updated event."
    
      if params[:commit] == 'Finish This Event'
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
