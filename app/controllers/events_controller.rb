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
  end

  def add_to_level
    
  end 
  # GET /events/1/edit
  def edit
  end
  
  
  #turns hp, exp, and gold into the JSON required for result
  def createResultJSON
    result = ""
    result += "[\"hp\":"
    result += @event.hp
    result += ",\"exp\":"
    result += @event.exp
    result += ", \"gold\":"
    result += @event.gold
    result += "]"
    result
  end
  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.game = Game.find(event_params[:game_id])
    @event.result = createResultJSON
    if @event.save
      flash[:success] = "Get new event created."
      if params[:commit] == 'Create this event'
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
    if @event.update(event_params)
      flash[:success] = "Successfully updated event."
      if params[:commit] == 'Create this event'
        redirect_to leveldashboard_url(@event.game_id)
      else
        redirect_to addevent_url(@event.game_id)
      end
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
      params.require(:event).permit(:name, :result, :description, :event_type, :image, :game_id, :hp, :exp, :gold)
    end
end
