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

  def events_to_names lev
    @names = Array.new
    if(lev.list_of_event_ids.to_s.strip.length != 0)
      event_ids = JSON.parse(lev.list_of_event_ids)
      event_ids.each do 
        |event_id| event = Event.find_by(id: event_id)
        @names.push(event.name)
      end
    end
    @names
  end
  helper_method :events_to_names

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
    len = curr_level.list_of_event_ids.to_s.strip.length
    
    #because the default JSON string is "[]"
    if(len > 2)
      curr_event_ids = JSON.parse(curr_level.list_of_event_ids)
    end
    curr_event_ids.push(@event_id)
    curr_level.list_of_event_ids= curr_event_ids.to_json
    event = Event.find_by(id: @event_id)
    if(curr_level.save)
      flash[:success] = "Great, " + event.name + " was added to the list"  
    end
    render 'assigneventforone'
  end

  def dequeueevent
    @game_id = params[:game_id]
    @level_id = params[:level_id]
    curr_level = Level.find_by(id: @level_id)
    len = curr_level.list_of_event_ids.to_s.strip.length
    
    #because the default JSON string is "[]"
    if(len <= 2)
      flash[:fail] = "No events to remove"
    else
      puts "~~~~~~~~~~~~~"
      puts curr_level.list_of_event_ids.to_s.strip
      puts "~~~~~~~~~~~~~"
      curr_event_ids = JSON.parse(curr_level.list_of_event_ids)
      curr_event = curr_event_ids.pop
      curr_event = Event.find_by(id: curr_event)
      curr_level.list_of_event_ids= curr_event_ids.to_json
      if(curr_level.save)
        flash[:success] = "Great, " + curr_event.name + " was removed from the list"  
      end
    end
    render 'assigneventforone'

  end

  def assigndoorforone
    @level_id = params['level_id']
    @game_id = params['game_id']
  end
  def queuedoor
    @game_id = params[:game_id]
    @level_id = params[:level_id]
    @door_id = params[:door_id]
    curr_level = Level.find_by(id: @level_id)
    curr_doors = Array.new
    len = curr_level.doors.to_s.strip.length
    
    #because the default JSON string is "[]"
    if(len > 2)
      curr_doors = JSON.parse(curr_level.doors)
    end
    curr_doors.push(@door_id)
    curr_level.doors = curr_doors.to_json
    door = Door.find_by(id: @door_id)
    if(curr_level.save)
      flash[:success] = "Great, " + door.name + " was added to the list"  
    end
    render 'assigndoorforone'
  end

  def dequeuedoor
    @game_id = params[:game_id]
    @level_id = params[:level_id]
    curr_level = Level.find_by(id: @level_id)
    len = curr_level.doors.to_s.strip.length
    
    #because the default JSON string is "[]"
    if(len <= 2)
      flash[:fail] = "No doors to remove"
    else
      curr_doors = JSON.parse(curr_level.doors)
      curr_door = curr_doors.pop
      curr_door = Event.find_by(id: curr_door)
      curr_level.doors= curr_doors.to_json
      if(curr_level.save)
        flash[:success] = "Great, " + curr_door.name + " was removed from the list"  
      end
    end
    render 'assigndoorforone'

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

    #@level.game = Game.find(level_params[:game_id])
  
    if @level.save
        flash[:success] = "Great! New level created."
        if params[:commit] == 'Finish this level and return to dashboard'
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
    if @level.update(level_params)
        if params[:commit] == 'Finish this level and return to dashboard'
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
      params.require(:level).permit(:name, :list_of_event_ids, :game_id, :doors, :description, :level_image)
    end
end
