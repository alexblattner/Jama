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

    respond_to do |format|
      if @door.save
        format.html { redirect_to @door, notice: 'Door was successfully created.' }
        format.json { render :show, status: :created, location: @door }
      else
        format.html { render :new }
        format.json { render json: @door.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doors/1
  # PATCH/PUT /doors/1.json
  def update
    respond_to do |format|
      if @door.update(door_params)
        format.html { redirect_to @door, notice: 'Door was successfully updated.' }
        format.json { render :show, status: :ok, location: @door }
      else
        format.html { render :edit }
        format.json { render json: @door.errors, status: :unprocessable_entity }
      end
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
      params.require(:door).permit(:name, :next_levels, :description, :image, :result, :requirement)
    end
end
