class EventInstancesController < ApplicationController
  before_action :set_event_instance, only: [:show, :edit, :update, :destroy]
  include GamestatesHelper
  include HeroesHelper
  # GET /event_instances
  # GET /event_instances.json
  def index
    @event_instances = EventInstance.all
  end

  # GET /event_instances/1
  # GET /event_instances/1.json
  def show
    @event_instance=EventInstance.find_by(id:params[:id])
    @gamestate=Gamestate.find_by(id: @event_instance.gamestate_id)
    uid=@gamestate.user_id
    @event=Event.find_by(id: @event_instance.event_id)
    re=JSON.parse(@event.requirement)
    @hero=Hero.find_by(id:@gamestate.hero_id)
    if !requirements_passed(@hero,re)
      @event_instance.progress="1"
      @event_instance.save
    end
   
    if @event_instance.progress!="1" && session[:user_id]==uid && requirements_passed(@hero,re)
      if @event.event_type=="direct"
        @hero=Hero.find_by(id: @gamestate.hero_id)
        @event_instance.progress="1"
        @event_instance.save
        json=JSON.parse(@event.result)
        hero_update(json,@hero)
        e=@event
      elsif @event.event_type=="fight"
        @hero=Hero.find_by(id: @gamestate.hero_id)
        p=@event_instance.progress
        d=false
        if p!="0"
          h=@event_instance.progress.delete_suffix('hp').to_i
          s=stats_calc(@hero.exp,@hero.hp)
          h=h-(s['rank']*10)
          if h<=0
            @event_instance.progress="1"
            d=true
          else
            @event_instance.progress=h.to_s+"hp"
          end
          @event_instance.save
          json=JSON.parse(@event.result)
          json=(h<=0)?json['death']:json['attack']
          hero_update(json,@hero)
        else
          json=JSON.parse(@event.result)
          @event_instance.progress=json['hp'].to_s+"hp"
          @event_instance.save
        end
        e=@event.to_json
        e=JSON.parse(e)
        if !d
        p=@event_instance.progress
        else
          p="1"
        end
        e['progress']=p
      elsif @event.event_type=="choice"
        e=@event
        if @event_instance.progress!="1"
          if params.key?("choice")
            r=JSON.parse(@event.result)
            ind=params['choice'].to_i
            if r[ind].key?("requirement")
              if requirements_passed(@hero,r[ind]['requirement'])
                e=[]
                r[ind]['events'].each{
                  |i|
                  e.push(EventInstance.create({:gamestate_id=>@gamestate.id,:level_id=>@gamestate.level_id,:progress=>"0",:event_id=>i}).id)
                }
                @event_instance.progress="1"
                @event_instance.save
              else
                e=[0]
              end
            else
              e=[]
              r[ind]['events'].each{
                |i|
                e.push(EventInstance.create({:gamestate_id=>@gamestate.id,:level_id=>@gamestate.level_id,:progress=>"0",:event_id=>i}).id)
              }
              @event_instance.progress="1"
              @event_instance.save
            end
          end
        end
      end
      render json: e.to_json()
    elsif @event_instance.progress=="1" && session[:user_id]==uid
      render json: [0,0].to_json
    else
      render json: {}.to_json()
    end
  end

  # GET /event_instances/new
  def new
    @event_instance = EventInstance.new
  end

  # GET /event_instances/1/edit
  def edit
  end

  # POST /event_instances
  # POST /event_instances.json
  def create
    @event_instance = EventInstance.new(event_instance_params)

    respond_to do |format|
      if @event_instance.save
        format.html { redirect_to @event_instance, notice: 'Event instance was successfully created.' }
        format.json { render :show, status: :created, location: @event_instance }
      else
        format.html { render :new }
        format.json { render json: @event_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_instances/1
  # PATCH/PUT /event_instances/1.json
  def update
    respond_to do |format|
      if @event_instance.update(event_instance_params)
        format.html { redirect_to @event_instance, notice: 'Event instance was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_instance }
      else
        format.html { render :edit }
        format.json { render json: @event_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_instances/1
  # DELETE /event_instances/1.json
  def destroy
    @event_instance.destroy
    respond_to do |format|
      format.html { redirect_to event_instances_url, notice: 'Event instance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_instance
      @event_instance = EventInstance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_instance_params
      params.require(:event_instance).permit(:gamestate_id, :level_id, :event_id, :progress)
    end
end
