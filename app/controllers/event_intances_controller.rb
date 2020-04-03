class EventIntancesController < ApplicationController
  before_action :set_event_intance, only: [:show, :edit, :update, :destroy]

  # GET /event_intances
  # GET /event_intances.json
  def index
    @event_intances = EventIntance.all
  end

  # GET /event_intances/1
  # GET /event_intances/1.json
  def show
  end

  # GET /event_intances/new
  def new
    @event_intance = EventIntance.new
  end

  # GET /event_intances/1/edit
  def edit
  end

  # POST /event_intances
  # POST /event_intances.json
  def create
    @event_intance = EventIntance.new(event_intance_params)

    respond_to do |format|
      if @event_intance.save
        format.html { redirect_to @event_intance, notice: 'Event intance was successfully created.' }
        format.json { render :show, status: :created, location: @event_intance }
      else
        format.html { render :new }
        format.json { render json: @event_intance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_intances/1
  # PATCH/PUT /event_intances/1.json
  def update
    respond_to do |format|
      if @event_intance.update(event_intance_params)
        format.html { redirect_to @event_intance, notice: 'Event intance was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_intance }
      else
        format.html { render :edit }
        format.json { render json: @event_intance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_intances/1
  # DELETE /event_intances/1.json
  def destroy
    @event_intance.destroy
    respond_to do |format|
      format.html { redirect_to event_intances_url, notice: 'Event intance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_intance
      @event_intance = EventIntance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_intance_params
      params.require(:event_intance).permit(:gamestate_id, :level_id, :event_id, :progress)
    end
end
