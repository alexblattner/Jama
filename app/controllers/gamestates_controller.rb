class GamestatesController < ApplicationController
before_action :set_gamestate, only: [:show, :edit, :update, :destroy]
require 'json'
include GamestatesHelper
  # GET /gamestates
  # GET /gamestates.json
  def index
    @gamestates = Gamestate.all
  end
  # POST /save/
  def save
    puts params
    puts params["id"]
    
  end
  # GET /gamestates/1
  # GET /gamestates/1.json
  def show
    if session[:user_id]!= @gamestate.user_id
    redirect_to action: 'index', status: 303
    end
    @level=Level.find_by(id: @gamestate.level_id)
    @hero=Hero.find_by(id: @gamestate.hero_id)
    @hero_level_info=stats_calc(@hero.exp,@hero.hp)
    eid=JSON.parse(@level.event_id)
    b = Hash.new(0)
    eid.each do |v|
      b[v] += 1
    end
    k=b.keys
    k.each{#creates event instances as amount specified
      |i|
      @instance=EventInstance.where({event_id:i,level_id:@gamestate.level_id,gamestate_id:@gamestate.id})
      c=@instance.count()
      w=b[i]-c
      while w>0
        EventInstance.create({:gamestate_id=>@gamestate.id,:level_id=>@gamestate.level_id,:progress=>"0",:event_id=>i})
        w-=1
      end
    }
    @instance=EventInstance.where({level_id:@gamestate.level_id,gamestate_id:@gamestate.id}).where.not(progress:"1");
    @arr=@instance.ids.to_json()
  end

  # GET /gamestates/new
  def new
    @gamestate = Gamestate.new
  end

  # GET /gamestates/1/edit
  def edit
  end

  # POST /gamestates
  # POST /gamestates.json
  def create
    @gamestate = Gamestate.new(gamestate_params)
    respond_to do |format|
      if @gamestate.save
        format.html { redirect_to @gamestate, notice: 'Gamestate was successfully created.' }
        format.json { render :show, status: :created, location: @gamestate }
      else
        format.html { render :new }
        format.json { render json: @gamestate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gamestates/1
  # PATCH/PUT /gamestates/1.json
  def update
    respond_to do |format|
      if @gamestate.update(gamestate_params)
        format.html { redirect_to @gamestate, notice: 'Gamestate was successfully updated.' }
        format.json { render :show, status: :ok, location: @gamestate }
      else
        format.html { render :edit }
        format.json { render json: @gamestate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gamestates/1
  # DELETE /gamestates/1.json
  def destroy
    @gamestate.destroy
    respond_to do |format|
      format.html { redirect_to gamestates_url, notice: 'Gamestate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gamestate
      @gamestate = Gamestate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gamestate_params
      params.require(:gamestate).permit(:user_id, :game_id, :hero_id)
    end
end
