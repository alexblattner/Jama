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

  def ids_to_events lev
    @events = Array.new
    if(lev.event_id.to_s.strip.length != 0)
      event_ids = JSON.parse(lev.event_id)
      event_ids.each do 
        |event_id| event = Event.find_by(id: event_id)
        @events.push(event)
      end
    end
    @events
  end
  helper_method :ids_to_events

  def doors_to_names lev
    @names = Array.new
    if(lev.doors.to_s.strip.length > 2)
      door_ids = JSON.parse(lev.doors)
      door_ids.each do 
        |door_id| door = Door.find_by(id: door_id)
        @names.push(door.name)
      end
    end
    @names
  end
  helper_method :doors_to_names

  def creategamelogic
    @game_id = params[:game_id]
  end

  def queueevent
    @game_id = params[:game_id]
    @level_id = params[:level_id]
    @event_id = params[:event_id]
    curr_level = Level.find_by(id: @level_id)
    curr_event_ids = Array.new
    len = curr_level.event_id.to_s.strip.length
    
    #because the default JSON string is "[]"
    if(len > 2)
      curr_event_ids = JSON.parse(curr_level.event_id)
    end
    curr_event_ids.push(@event_id)
    curr_level.event_id= curr_event_ids.to_json
    event = Event.find_by(id: @event_id)
    if(curr_level.save)
      flash[:success] = "Great, " + event.name + " was added to the list"  
    end
    render 'assigneventforone'
  end

  def dequeueevent
    @game_id = params[:game_id]
    @level_id = params[:level_id]
    @pointer = params[:counter]
    curr_level = Level.find_by(id: @level_id)
    len = curr_level.event_id.to_s.strip.length
    
    #because the default JSON string is "[]"
    if(len <= 2)
      flash[:fail] = "No events to remove"
    else
      curr_event_ids = JSON.parse(curr_level.event_id)
      curr_event = curr_event_ids.delete_at(@pointer.to_i)
      curr_event = Event.find_by(id: curr_event)
      curr_level.event_id= curr_event_ids.to_json
      if(curr_level.save)
        flash[:success] = "Great, " + curr_event.name + " was removed from the list"  
      end
    end
    render 'assigneventforone'

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
    if params.has_key? "id"
      g=Gamestate.find_by(id: params['id'])
      l=Level.find_by(id: g.level_id)
      arr=[]
      if l.doors.length>0
        arr=JSON.parse(l.doors)
      end
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
      else
        render json: [].to_json
      end
    end
  end

  def designatestart
    @game_id = params['game_id']
    @game = Game.find_by(id: @game_id)
  end
  def organizeevents
    @level = Level.find_by(id: params['level_id'])
    @game = Game.find_by(id: params['game_id'])
    render 'edit'
  end
  # POST /levels
  # POST /levels.json
  def create
    @level = Level.new(level_params)
    @events = Array.new
    @level.event_id = @events.to_json
    #@level.game = Game.find(level_params[:game_id])
    #@level.image = url_for(@level.level_image)
    if(!@level.level_image.attached?)
      @level.level_image.attach(io: File.open("app/assets/images/samplegame2.jpg"), filename: "samplegame2.jpg")
    end
    @level.image = @level.level_image.service_url
   
    doors = Array.new
    @level.doors = doors.to_json
    if @level.save
        flash[:success] = "Great! New level created."
        if params[:commit] == 'Finish This Level'
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
    # @level.image = url_for(@level.level_image)
    if(!@level.level_image.attached?)
      @level.level_image.attach(io: File.open("app/assets/images/samplegame2.jpg"), filename: "samplegame2.jpg")
    end
    @level.image = @level.level_image.service_url
    if @level.update(level_params)
        if params[:commit] == 'Save & Finish'
          redirect_to leveldashboard_url(@level.game_id)
        elsif params[:commit] == 'Add events'
            redirect_to assigneventforall_path(@level.game_id)
        else
          redirect_to addlevel_url(@level.game_id)
        end
    else 
      render "edit"
    end
  end
  def assigneventforall
    @game_id = params['game_id']
  end
  def assigneventforone
    @game_id = params['game_id']
    @level_id = params['level_id']
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
      params.require(:level).permit(:name, :event_id, :game_id, :doors, :description, :level_image, :image)
    end
end
