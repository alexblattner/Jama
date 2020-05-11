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
    @games = Game.where.not(admin_id: session['user_id'])
    render "all"
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
    g = GraphViz.new( :G, :type => :digraph)
    @levels = Level.where(game_id: @game_id)
    @doors = Door.where(game_id: @game_id)
    valid = true
    visited_door = Array.new
    visited_level = Array.new
    door_queue = Array.new
    level_queue = Array.new
    @errors = Array.new
    level_nodes = Hash.new
    @levels.each do |level|
      level_nodes[level.id] = g.add_nodes(level.name, :fontname => "Courier")
      visited_level[level.id] = false
    end
    door_nodes = Hash.new
    @doors.each do |door|
      door_nodes[door.id] = g.add_nodes(door.name, :shape => 'square', :fontname => "Courier")
      visited_level[door.id] = false
    end
    # Breadth first search with an extra step for doors
    if(!@start_level_id.nil?)
      level_queue.push(@start_level_id)
      while level_queue.length > 0
        curr = level_queue.pop
        if !(visited_level[curr])
          visited_level[curr] = true
          curr_level = @levels.find(curr)
          next_doors = curr_level.doors
          door_queue = JSON.parse(next_doors)
          while door_queue.length > 0
            curr_door = door_queue.pop
            if !(visited_door[curr_door])
              visited_door[curr_door] = true
              puts "*******"
              puts curr
              puts curr_door
              puts "**********"
              g.add_edges(level_nodes[curr], door_nodes[curr_door])
              door_pointer = @doors.find(curr_door)
              next_levels = JSON.parse(door_pointer.next_levels)
              next_levels.each do |level|
                if !visited_level[level.to_i]
                  level_queue.push(level.to_i)
                end
                puts "*******"
                puts level
                puts curr_door
                puts "**********"
                g.add_edges(door_nodes[curr_door], level_nodes[level.to_i])
              end
            end
          end
        end
      end
    else
      @errors.push("No starting level")
      valid = false
    end
    g.output( :png => "app/assets/images/hello_world.png" )  
    @game.graph_image.attach(io: File.open("app/assets/images/hello_world.png"), filename: "hello_world.png")
    t = GraphViz::Theory.new( g )
    g.each_node do |name, node|
      if t.degree(node) == 0
        @errors.push("Unconnected level: #{name}")
        valid = false
      end
    end
    return valid
  end 

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    @game.admin_id = session['user_id']
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
