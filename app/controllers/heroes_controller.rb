class HeroesController < ApplicationController
  before_action :set_hero, only: [:show, :edit, :update, :destroy]

  # GET /heroes
  # GET /heroes.json
  def index
    @heroes = Hero.all
  end

  # GET /heroes/1
  # GET /heroes/1.json
  def show
  end

  # GET /heroes/new
  def new
    @hero = Hero.new

  end

  # GET /heroes/1/edit
  def edit
  end

  # POST /heroes
  # POST /heroes.json
  def create
    @gamestate_id = hero_params['gamestate_id']
    #hero_params.delete('gamestate_id')
    h = hero_params.reject { |k,v| k == 'gamestate_id' }
   
    @hero = Hero.new(h)

    @hero.hp = 100
    @hero.exp = 0
    @hero.gold = 0
    @hero.image = @hero.hero_image.service_url
    if @hero.save
 
      @gamestate = Gamestate.find_by(id: @gamestate_id)
      @gamestate.hero_id = @hero.id
      @gamestate.save 
      redirect_to gamestate_url(@gamestate.id)
    else
        render 'new'
    end
    end

  # PATCH/PUT /heroes/1
  # PATCH/PUT /heroes/1.json
  def update
    respond_to do |format|
      if @hero.update(hero_params)
        format.html { redirect_to @hero, notice: 'Hero was successfully updated.' }
        format.json { render :show, status: :ok, location: @hero }
      else
        format.html { render :edit }
        format.json { render json: @hero.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /heroes/1
  # DELETE /heroes/1.json
  def destroy
    @hero.destroy
    respond_to do |format|
      format.html { redirect_to heroes_url, notice: 'Hero was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hero
      @hero = Hero.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hero_params
      params.require(:hero).permit(:name, :exp, :hp, :gold, :hero_image, :gamestate_id, :image)
    end
end
