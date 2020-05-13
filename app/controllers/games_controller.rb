class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  include UsersHelper
  include SessionsHelper


  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    render "new"
  end

  # GET /games/new
  def new
    @game = Game.new
  end


  
  def all
    @games = Game.search(params[:search]).where.not(admin_id: session['user_id']).paginate(:per_page => 20,:page => params[:page]).order(:popularity)
    @self=Game.search(params[:search]).where(admin_id: session['user_id']).paginate(:per_page => 20,:page => params[:page])
    render "all"
  end
  def barload
    @games = Game.search(params[:search]).where.not(admin_id: session['user_id']).paginate(:per_page => 20,:page => params[:page])
    @self=Game.search(params[:search]).where(admin_id: session['user_id']).paginate(:per_page => 20,:page => params[:page])
    render layout: false
  end
  def startinglevel
    @game_id = params[:game_id]
    @level_id = params[:level_id]
    @game = Game.find_by(id: @game_id)
    @game.start_level_id = @level_id
    if(@game.save)
      flash[:success] = "Starting level set"
    else
      flash[:fail] = "Failed to set starting level"
    end
    render 'levels/designatestart', game_id: @game_id
  end


  # GET /games/1/edit
  def edit
  end
 
  def review
    @valid = valid()
  end
  require 'graphviz/theory'
  def valid
    @game_id = params[:game_id]
    @game = Game.find_by(id: @game_id)
    @start_level_id = @game.start_level_id
    @levels = Level.where(game_id: @game_id)
    @doors = Door.where(game_id: @game_id)
    hash = Games::Graph.new(@game, @start_level_id, @levels, @doors, @errors).valid
    valid = hash[:valid]
    @errors = hash[:errors]
    valid
  end 

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    @game.admin_id = session['user_id']
    @game.popularity = 1
    if @game.save
        flash[:success] = "Great! New game created, let's add some levels to the game."
        #puts @game.id 
        redirect_to leveldashboard_url(@game.id)
    else
        render "new"
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:game_name, :start_level_id, :description, :admin_id, :image_url, :popularity, :game_image)
    end
end
